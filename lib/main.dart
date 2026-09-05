import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'update_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TvAntoApp());
}

class TvAntoApp extends StatelessWidget {
  const TvAntoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TV Anto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0a0a0f),
        primaryColor: const Color(0xFFEC4899),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFEC4899),
          secondary: Color(0xFFFBBF24),
          surface: Color(0xFF16161f),
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class Channel {
  final String name;
  final String url;
  final String logo;
  final String group;

  const Channel({
    required this.name,
    required this.url,
    required this.logo,
    required this.group,
  });
}

enum ViewMode { mobile, tvBox }

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Channel> channels = const [
    // CANALES ORIGINALES
    Channel(
      name: '⭐ Win+ Sports',
      url: 'https://streamtp-golden1.click/global1.php?stream=winplus',
      logo: 'https://i.imgur.com/XSL1gd7.png',
      group: 'FUTBOL-ANTO',
    ),
    Channel(
      name: '⭐ DSports',
      url: 'https://streamtp-golden1.click/global1.php?stream=dsports',
      logo: 'https://i.imgur.com/LmkNt3v.png',
      group: 'FUTBOL-ANTO',
    ),
    Channel(
      name: '⭐ ESPN',
      url: 'https://streamtp-golden1.click/global1.php?stream=espn',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/ESPN_wordmark.svg/1024px-ESPN_wordmark.svg.png',
      group: 'DEPORTES',
    ),
    // NUEVOS CANALES
    Channel(
      name: '⭐ Disney 13',
      url: 'https://la18hd.su/vivo/canal.php?stream=disney13',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/ESPN_logo.svg/512px-ESPN_logo.svg.png',
      group: 'DEPORTES',
    ),
    Channel(
      name: '⭐ ESPN 3 MX',
      url: 'https://la18hd.su/vivo/canal.php?stream=espn3mx',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/51/ESPN3_Logo.png/512px-ESPN3_Logo.png',
      group: 'DEPORTES',
    ),
    Channel(
      name: '⭐ Fox Sports MX',
      url: 'https://la18hd.su/vivo/canal.php?stream=foxsportsmx',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Fox_Sports_MX.svg/512px-Fox_Sports_MX.svg.png',
      group: 'DEPORTES',
    ),
    Channel(
      name: '⭐ Fox Sports 2 MX',
      url: 'https://la18hd.su/vivo/canal.php?stream=foxsports2mx',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8d/Fox_Sports_2_logo.svg/512px-Fox_Sports_2_logo.svg.png',
      group: 'DEPORTES',
    ),
    Channel(
      name: '⭐ Fox Sports Premium',
      url: 'https://la18hd.su/vivo/canal.php?stream=foxsportspremium',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b2/Fox_Sports_Premium_%28Argentina%29_-_2018_logo.svg/512px-Fox_Sports_Premium_%28Argentina%29_-_2018_logo.svg.png',
      group: 'DEPORTES',
    ),
    Channel(
      name: '⭐ Fox Deportes',
      url: 'https://la18hd.su/vivo/canal.php?stream=foxdeportes',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e5/Fox_Deportes_logo.svg/512px-Fox_Deportes_logo.svg.png',
      group: 'DEPORTES',
    ),
    Channel(
      name: '⭐ ESPN MX',
      url: 'https://la18hd.su/vivo/canal.php?stream=espnmx',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/ESPN_wordmark.svg/512px-ESPN_wordmark.svg.png',
      group: 'DEPORTES',
    ),
    Channel(
      name: '⭐ Premiere 1',
      url: 'https://streamtp-golden1.click/global2.php?stream=premiere1',
      logo: 'https://upload.wikimedia.org/wikipedia/pt/thumb/7/7f/Premiere_FC_2018.png/512px-Premiere_FC_2018.png',
      group: 'DEPORTES',
    ),
  ];

  Channel? _currentChannel;
  bool _isLoading = true;
  String _errorMessage = '';

  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  ViewMode _viewMode = ViewMode.mobile;
  bool _showSettings = false;
  bool _zoomMode = false;
  bool _showTVFrame = true;
  double _videoZoom = 1.0;

  @override
  void initState() {
    super.initState();
    _currentChannel = channels[0];
    _loadPreferences();
    _extractAndPlay(_currentChannel!.url);
    WakelockPlus.enable(); // Mantener pantalla encendida
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkRemoteConfig());
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _viewMode = ViewMode.values[prefs.getInt('viewMode') ?? 0];
      _showTVFrame = prefs.getBool('showTVFrame') ?? true;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('viewMode', _viewMode.index);
    await prefs.setBool('showTVFrame', _showTVFrame);
  }

  Future<void> _checkRemoteConfig() async {
    final config = await UpdateService.fetchConfig();
    if (config == null || !mounted) return;

    // 1) Mensaje / aviso (se muestra una vez por id)
    if (config.hasMessage) {
      final prefs = await SharedPreferences.getInstance();
      final seenId = prefs.getString('seenMessageId');
      if (config.messageId == null || config.messageId != seenId) {
        if (!mounted) return;
        await _showMessageDialog(config);
        if (config.messageId != null) {
          await prefs.setString('seenMessageId', config.messageId!);
        }
      }
    }

    // 2) Aviso de actualización
    final latest = UpdateService.latestForPlatform(config);
    if (latest == null || !mounted) return;
    final current = await UpdateService.currentVersion();
    if (current == null || !mounted) return;
    if (UpdateService.isNewer(latest.version, current)) {
      await _showUpdateDialog(latest.version, latest.url, latest.force);
    }
  }

  Future<void> _showMessageDialog(RemoteConfig config) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(config.messageTitle ?? 'TV Anto'),
        content: Text(config.messageBody ?? ''),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
          if (config.messageUrl != null && config.messageUrl!.isNotEmpty)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _openUrl(config.messageUrl!);
              },
              child: const Text('Ver'),
            ),
        ],
      ),
    );
  }

  Future<void> _showUpdateDialog(String version, String url, bool force) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: !force,
      builder: (context) => AlertDialog(
        title: const Text('🔄 Actualización disponible'),
        content: Text(
          'Hay una nueva versión ($version) de TV Anto. '
          'Actualiza para seguir disfrutando de los canales.',
        ),
        actions: [
          if (!force)
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Ahora no'),
            ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _openUrl(url);
            },
            child: const Text('Actualizar aquí'),
          ),
        ],
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // Si no se puede abrir el enlace, no interrumpimos la app.
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  Future<void> _extractAndPlay(String pageUrl) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    _videoPlayerController = null;
    _chewieController = null;

    try {
      String finalUrl = pageUrl;
      if (kIsWeb) {
        finalUrl = '/api/proxy?url=${Uri.encodeComponent(pageUrl)}';
      }

      final response = await http.get(
        Uri.parse(finalUrl),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
          'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Tiempo de espera agotado.');
        },
      );

      if (response.statusCode == 403) {
        throw Exception('Acceso bloqueado. Intenta con otro canal.');
      }

      if (response.statusCode != 200) {
        throw Exception('Error al contactar el servidor. (Código: ${response.statusCode})');
      }

      final regex = RegExp(r'var playbackURL\s*=\s*"(.*?)";');
      final match = regex.firstMatch(response.body);

      if (match == null) {
        throw Exception('No se pudo extraer la transmisión.');
      }

      String m3u8Url = match.group(1)!;
      m3u8Url = m3u8Url.replaceAll(r'\/', '/');

      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(m3u8Url));
      await _videoPlayerController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        isLive: true,
        showControlsOnInitialize: false,
        allowFullScreen: true,
        allowMuting: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(errorMessage, style: const TextStyle(color: Colors.white)),
          );
        },
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  void _changeChannel(Channel channel) {
    if (_currentChannel?.url == channel.url) return;

    setState(() {
      _currentChannel = channel;
    });

    _extractAndPlay(channel.url);
  }

  @override
  Widget build(BuildContext context) {
    if (_viewMode == ViewMode.tvBox) {
      return _buildTVBoxMode();
    } else {
      return _buildMobileMode();
    }
  }

  Widget _buildMobileMode() {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      drawer: isDesktop ? null : Drawer(child: _buildSidebar()),
      body: Row(
        children: [
          if (isDesktop) _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildHeader(isDesktop),
                Expanded(child: _buildVideoPlayer()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTVBoxMode() {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Video Player
            _buildVideoPlayer(),

            // Mini Channel List (Bottom)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: channels.length,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    final channel = channels[index];
                    final isSelected = _currentChannel?.url == channel.url;
                    return GestureDetector(
                      onTap: () => _changeChannel(channel),
                      child: Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFEC4899) : Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: isSelected ? Colors.white : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              channel.logo,
                              height: 40,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.live_tv, size: 40),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              channel.name,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Mode Switcher
            Positioned(
              top: 10,
              right: 10,
              child: _buildModeSwitcher(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    Widget videoWidget;

    if (_isLoading) {
      videoWidget = _buildLoadingState();
    } else if (_errorMessage.isNotEmpty) {
      videoWidget = _buildErrorState();
    } else if (_chewieController != null) {
      videoWidget = Transform.scale(
        scale: _videoZoom,
        child: Chewie(controller: _chewieController!),
      );
    } else {
      videoWidget = const SizedBox();
    }

    // Add TV Frame if enabled and not in zoom mode
    if (_showTVFrame && !_zoomMode && _viewMode == ViewMode.mobile) {
      videoWidget = Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF1a1a1a), width: 20),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: videoWidget,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [
            const Color(0xFF16161f).withOpacity(0.5),
            const Color(0xFF0a0a0f),
          ],
        ),
      ),
      child: Stack(
        children: [
          Center(child: videoWidget),

          // Watermark
          if (!_isLoading && _errorMessage.isEmpty && _chewieController != null)
            Positioned(
              bottom: 80,
              right: 20,
              child: Opacity(
                opacity: 0.4,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/img/logo.jpg',
                        height: 30,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.live_tv, size: 30),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'TV Anto',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Settings Button
          if (_viewMode == ViewMode.mobile)
            Positioned(
              top: 10,
              right: 10,
              child: Row(
                children: [
                  _buildModeSwitcher(),
                  const SizedBox(width: 10),
                  FloatingActionButton(
                    mini: true,
                    backgroundColor: const Color(0xFFEC4899),
                    onPressed: () {
                      setState(() {
                        _showSettings = !_showSettings;
                      });
                    },
                    child: Icon(_showSettings ? Icons.close : Icons.settings),
                  ),
                ],
              ),
            ),

          // Settings Panel
          if (_showSettings && _viewMode == ViewMode.mobile)
            Positioned(
              top: 70,
              right: 10,
              child: _buildSettingsPanel(),
            ),
        ],
      ),
    );
  }

  Widget _buildModeSwitcher() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildModeButton(Icons.phone_android, ViewMode.mobile, 'Móvil'),
          const SizedBox(width: 5),
          _buildModeButton(Icons.tv, ViewMode.tvBox, 'TV Box'),
        ],
      ),
    );
  }

  Widget _buildModeButton(IconData icon, ViewMode mode, String label) {
    final isSelected = _viewMode == mode;
    return GestureDetector(
      onTap: () {
        setState(() {
          _viewMode = mode;
        });
        _savePreferences();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFEC4899), Color(0xFFFBBF24)],
                )
              : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsPanel() {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF16161f), Color(0xFF0a0a0f)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEC4899), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEC4899).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '⚙️ Configuración',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFEC4899),
            ),
          ),
          const SizedBox(height: 16),

          // Zoom Control
          _buildSettingItem(
            icon: Icons.zoom_in,
            label: 'Zoom: ${_videoZoom.toStringAsFixed(1)}x',
            child: Slider(
              value: _videoZoom,
              min: 1.0,
              max: 2.0,
              divisions: 10,
              onChanged: (value) {
                setState(() {
                  _videoZoom = value;
                  _zoomMode = value > 1.0;
                });
              },
              activeColor: const Color(0xFFFBBF24),
            ),
          ),

          // TV Frame Toggle
          _buildSettingItem(
            icon: Icons.border_outer,
            label: 'Marco TV',
            child: Switch(
              value: _showTVFrame,
              onChanged: (value) {
                setState(() {
                  _showTVFrame = value;
                });
                _savePreferences();
              },
              activeColor: const Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String label,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Colors.white70),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                const Color(0xFFEC4899).withOpacity(0.2),
                const Color(0xFFFBBF24).withOpacity(0.2),
              ],
            ),
          ),
          child: const SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEC4899)),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Cargando transmisión...',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(32),
      constraints: const BoxConstraints(maxWidth: 500),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.withOpacity(0.1),
            Colors.orange.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withOpacity(0.3), width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 56),
          const SizedBox(height: 16),
          const Text(
            '¡Ups! Algo salió mal',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            _errorMessage,
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  if (_currentChannel != null) {
                    _extractAndPlay(_currentChannel!.url);
                  }
                },
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: const Text('Reintentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEC4899),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  final currentIndex = channels.indexOf(_currentChannel!);
                  final nextIndex = (currentIndex + 1) % channels.length;
                  _changeChannel(channels[nextIndex]);
                },
                icon: const Icon(Icons.skip_next_rounded, size: 20),
                label: const Text('Otro canal'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withOpacity(0.3), width: 1.5),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDesktop) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF16161f), Color(0xFF0a0a0f)],
        ),
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Row(
        children: [
          if (!isDesktop)
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          if (_currentChannel != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.network(
                _currentChannel!.logo,
                height: 32,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.live_tv_rounded, size: 32),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentChannel!.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'EN VIVO',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0a0a0f), Color(0xFF16161f)],
        ),
        border: Border(right: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFEC4899).withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/img/logo.jpg',
                height: 150,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.live_tv_rounded, size: 80, color: Color(0xFFEC4899)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: channels.length,
              itemBuilder: (context, index) {
                final channel = channels[index];
                final isSelected = _currentChannel?.url == channel.url;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => _changeChannel(channel),
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [Color(0xFFEC4899), Color(0xFFFBBF24)],
                              )
                            : null,
                        color: isSelected ? null : Colors.white.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.network(
                              channel.logo,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.live_tv, size: 24),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              channel.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
