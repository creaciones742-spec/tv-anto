document.addEventListener('DOMContentLoaded', () => {
    const categoriesContainer = document.getElementById('categories-container');
    const videoPlayer = document.getElementById('video-player');
    const loadingSpinner = document.getElementById('loading-spinner');
    const errorMessage = document.getElementById('error-message');
    const currentLogo = document.getElementById('current-logo');
    const currentTitle = document.getElementById('current-title');
    const currentGroup = document.getElementById('current-group');
    const mobileMenuBtn = document.getElementById('mobile-menu-btn');
    const sidebar = document.querySelector('.sidebar');
    const searchInput = document.getElementById('search-input');
    const searchClear = document.getElementById('search-clear');

    let hls = null;
    let currentChannelElement = null;
    let allChannelElements = []; // Store references for search

    // Group channels by category
    const groupedChannels = channels.reduce((acc, channel) => {
        const group = channel.group || 'General';
        if (!acc[group]) {
            acc[group] = [];
        }
        acc[group].push(channel);
        return acc;
    }, {});

    // Sort categories alphabetically, but put "★ Principal" first
    const sortedCategories = Object.keys(groupedChannels).sort((a, b) => {
        if (a.startsWith('★')) return -1;
        if (b.startsWith('★')) return 1;
        return a.localeCompare(b);
    });

    // Render Sidebar
    sortedCategories.forEach(categoryName => {
        const categoryDiv = document.createElement('div');
        categoryDiv.className = 'category';
        categoryDiv.dataset.category = categoryName;

        const categoryTitle = document.createElement('div');
        categoryTitle.className = 'category-title';
        categoryTitle.textContent = categoryName;

        const channelList = document.createElement('div');
        channelList.className = 'channel-list';

        groupedChannels[categoryName].forEach(channel => {
            const channelItem = document.createElement('div');
            channelItem.className = 'channel-item';
            channelItem.dataset.name = channel.name.toLowerCase();
            channelItem.dataset.group = (channel.group || '').toLowerCase();
            
            // Build inner HTML for channel
            let logoHtml = `<div class="channel-logo"><i class="fa-solid fa-tv"></i></div>`;
            if (channel.logo) {
                logoHtml = `<img src="${channel.logo}" class="channel-logo" onerror="this.outerHTML='<div class=\\'channel-logo\\'><i class=\\'fa-solid fa-tv\\'></i></div>'" alt="${channel.name}">`;
            }

            channelItem.innerHTML = `
                ${logoHtml}
                <div class="channel-info">
                    <div class="channel-name" title="${channel.name}">${channel.name}</div>
                </div>
            `;

            channelItem.addEventListener('click', () => {
                playChannel(channel, channelItem);
                
                // Close sidebar on mobile after selection
                if (window.innerWidth <= 900) {
                    sidebar.classList.remove('open');
                }
            });

            channelList.appendChild(channelItem);
            allChannelElements.push({ element: channelItem, category: categoryDiv, channel: channel });
        });

        categoryDiv.appendChild(categoryTitle);
        categoryDiv.appendChild(channelList);
        categoriesContainer.appendChild(categoryDiv);
    });

    // =====================
    // Search Functionality
    // =====================
    searchInput.addEventListener('input', () => {
        const query = searchInput.value.trim().toLowerCase();

        // Toggle clear button
        if (query.length > 0) {
            searchClear.classList.remove('hidden');
        } else {
            searchClear.classList.add('hidden');
        }

        filterChannels(query);
    });

    searchClear.addEventListener('click', () => {
        searchInput.value = '';
        searchClear.classList.add('hidden');
        filterChannels('');
        searchInput.focus();
    });

    function filterChannels(query) {
        // Remove previous no-results message
        const existingNoResults = categoriesContainer.querySelector('.no-results');
        if (existingNoResults) existingNoResults.remove();

        let visibleCount = 0;

        // Track which categories have visible items
        const categoryVisibility = {};

        allChannelElements.forEach(item => {
            const nameMatch = item.element.dataset.name.includes(query);
            const groupMatch = item.element.dataset.group.includes(query);
            const match = nameMatch || groupMatch;

            if (query === '' || match) {
                item.element.style.display = 'flex';
                categoryVisibility[item.channel.group || 'General'] = true;
                visibleCount++;
            } else {
                item.element.style.display = 'none';
            }
        });

        // Show/hide entire category blocks
        const categoryDivs = categoriesContainer.querySelectorAll('.category');
        categoryDivs.forEach(cat => {
            const catName = cat.dataset.category;
            if (query === '' || categoryVisibility[catName]) {
                cat.style.display = 'block';
            } else {
                cat.style.display = 'none';
            }
        });

        // Show "no results" if nothing matches
        if (visibleCount === 0 && query !== '') {
            const noResults = document.createElement('div');
            noResults.className = 'no-results';
            noResults.innerHTML = `<i class="fa-solid fa-face-sad-tear"></i>No se encontraron canales para "<strong>${query}</strong>"`;
            categoriesContainer.appendChild(noResults);
        }
    }

    function playChannel(channel, element) {
        // Update active states
        if (currentChannelElement) {
            currentChannelElement.classList.remove('active');
        }
        element.classList.add('active');
        currentChannelElement = element;

        // Update header info
        currentTitle.textContent = channel.name;
        if (channel.logo) {
            currentLogo.src = channel.logo;
            currentLogo.classList.remove('hidden');
        } else {
            currentLogo.classList.add('hidden');
            currentLogo.src = '';
        }
        currentGroup.textContent = channel.group || 'General';
        currentGroup.classList.remove('hidden');

        // Reset UI states
        errorMessage.classList.add('hidden');
        loadingSpinner.classList.remove('hidden');

        const iframePlayer = document.getElementById('iframe-player');

        // Clean up previous HLS instance if it exists
        if (hls) {
            hls.destroy();
            hls = null;
        }
        
        videoPlayer.pause();
        videoPlayer.removeAttribute('src');
        videoPlayer.load();

        // Check if the URL is a web page instead of a stream manifest
        // .php pages, or specific player embeds, should be opened in an iframe.
        if (channel.url.includes('.php') || channel.type === 'iframe') {
            videoPlayer.classList.add('hidden');
            iframePlayer.classList.remove('hidden');
            iframePlayer.src = channel.url;
            
            iframePlayer.onload = () => {
                loadingSpinner.classList.add('hidden');
            };

            // Safety timeout in case iframe onload doesn't fire
            setTimeout(() => {
                loadingSpinner.classList.add('hidden');
            }, 3000);
            return;
        }

        // If it's a normal stream, make sure video player is visible
        videoPlayer.classList.remove('hidden');
        iframePlayer.classList.add('hidden');
        iframePlayer.src = '';

        if (Hls.isSupported()) {
            hls = new Hls({
                debug: false,
                enableWorker: true
            });
            hls.loadSource(channel.url);
            hls.attachMedia(videoPlayer);

            // Timeout: if no manifest after 15 seconds, show error
            let loadTimeout = setTimeout(() => {
                loadingSpinner.classList.add('hidden');
                errorMessage.classList.remove('hidden');
            }, 15000);

            let networkRetries = 0;
            
            hls.on(Hls.Events.MANIFEST_PARSED, function() {
                clearTimeout(loadTimeout);
                loadingSpinner.classList.add('hidden');
                const playPromise = videoPlayer.play();
                if (playPromise !== undefined) {
                    playPromise.catch(error => {
                        console.log("Auto-play prevented", error);
                    });
                }
            });

            hls.on(Hls.Events.ERROR, function(event, data) {
                if (data.fatal) {
                    switch (data.type) {
                        case Hls.ErrorTypes.NETWORK_ERROR:
                            networkRetries++;
                            if (networkRetries <= 2) {
                                console.error("Network error, retrying...", networkRetries);
                                hls.startLoad();
                            } else {
                                clearTimeout(loadTimeout);
                                loadingSpinner.classList.add('hidden');
                                errorMessage.classList.remove('hidden');
                            }
                            break;
                        case Hls.ErrorTypes.MEDIA_ERROR:
                            console.error("fatal media error encountered, try to recover");
                            hls.recoverMediaError();
                            break;
                        default:
                            clearTimeout(loadTimeout);
                            loadingSpinner.classList.add('hidden');
                            errorMessage.classList.remove('hidden');
                            hls.destroy();
                            break;
                    }
                }
            });
        }
        else if (videoPlayer.canPlayType('application/vnd.apple.mpegurl')) {
            videoPlayer.src = channel.url;
            videoPlayer.addEventListener('loadedmetadata', function() {
                loadingSpinner.classList.add('hidden');
                videoPlayer.play();
            });
            videoPlayer.addEventListener('error', function() {
                loadingSpinner.classList.add('hidden');
                errorMessage.classList.remove('hidden');
            });
        } else {
            loadingSpinner.classList.add('hidden');
            errorMessage.querySelector('p').textContent = "Tu navegador no soporta reproducción HLS.";
            errorMessage.classList.remove('hidden');
        }
    }

    // Mobile Menu Toggle
    mobileMenuBtn.addEventListener('click', () => {
        sidebar.classList.toggle('open');
    });

    // Close sidebar when clicking outside on mobile
    document.addEventListener('click', (e) => {
        if (window.innerWidth <= 900 && 
            !sidebar.contains(e.target) && 
            !mobileMenuBtn.contains(e.target) && 
            sidebar.classList.contains('open')) {
            sidebar.classList.remove('open');
        }
    });

    // =====================
    // Auto-play Principal Channel on load
    // =====================
    if (allChannelElements.length > 0) {
        const principal = allChannelElements[0];
        playChannel(principal.channel, principal.element);
        // Scroll to make sure it's visible
        principal.element.scrollIntoView({ block: 'nearest' });
    }
});
