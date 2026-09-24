import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'onesignal_service.dart';
import 'update_service.dart';
import 'theme.dart';

/// App ID de OneSignal (notificaciones push).
const String kOneSignalAppId = '0d6bfe44-46d5-4498-8953-b1bfe508cb47';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) MediaKit.ensureInitialized();
  OneSignalService.instance.initialize(kOneSignalAppId);
  runApp(const TvAntoApp());
}

class TvAntoApp extends StatelessWidget {
  const TvAntoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TV Anto',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
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
    // CANALES TVF90
    Channel(
      name: '⭐ DSports +',
      url: 'https://tvf90.com/5.php?stream=dsportsplus',
      logo: 'https://i.imgur.com/LmkNt3v.png',
      group: 'DEPORTES',
    ),
    Channel(
      name: '⭐ ESPN HD',
      url: 'https://tvf90.com/5.php?stream=espn',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/ESPN_wordmark.svg/1024px-ESPN_wordmark.svg.png',
      group: 'DEPORTES',
    ),
    Channel(
      name: '⭐ Liga 1 Max',
      url: 'https://tvf90.com/5.php?stream=liga1max',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/Liga1_Max_logo.png/512px-Liga1_Max_logo.png',
      group: 'DEPORTES',
    ),
    Channel(
      name: '⭐ Telemundo',
      url: 'https://tvf90.com/5.php?stream=telemundo',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1d/Telemundo_logo.svg/512px-Telemundo_logo.svg.png',
      group: 'DEPORTES',
    ),
    Channel(
      name: '⭐ Liga Pro ECU',
      url: 'https://tvf90.com/5.php?stream=ecdf_ligapro',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/85/LigaPro_Logo.png/512px-LigaPro_Logo.png',
      group: 'DEPORTES',
    ),
    Channel(
      name: '⭐ Win Sports 2',
      url: 'https://tvf90.com/5.php?stream=winsports2',
      logo: 'https://i.imgur.com/XSL1gd7.png',
      group: 'DEPORTES',
    ),
    Channel(
      name: '⭐ SporTV',
      url: 'https://tvf90.com/5.php?stream=sportv',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/SporTV_logo.svg/512px-SporTV_logo.svg.png',
      group: 'DEPORTES',
    ),
    Channel(
      name: '⭐ TNT Sports Chile',
      url: 'https://tvf90.com/5.php?stream=tntsportschile',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/56/TNT_Sports_Chile_logo.svg/512px-TNT_Sports_Chile_logo.svg.png',
      group: 'DEPORTES',
    ),
    Channel(
      name: '⭐ ESPN 3',
      url: 'https://tvf90.com/5.php?stream=espn3',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/51/ESPN3_Logo.png/512px-ESPN3_Logo.png',
      group: 'DEPORTES',
    ),
    Channel(
      name: '⭐ Canal 5',
      url: 'https://tvf90.com/5.php?stream=canal5',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Canal_5_(Mexico)_logo.svg/512px-Canal_5_(Mexico)_logo.svg.png',
      group: 'DEPORTES',
    ),
    Channel(
      name: '⭐ TUDN',
      url: 'https://tvf90.com/5.php?stream=tudn',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/28/TUDN_logo.svg/512px-TUDN_logo.svg.png',
      group: 'DEPORTES',
    ),
    Channel(
      name: '⭐ Universo',
      url: 'https://tvf90.com/5.php?stream=universo',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/98/Universo_logo.svg/512px-Universo_logo.svg.png',
      group: 'DEPORTES',
    ),
    Channel(
      name: '⭐ Win Sports',
      url: 'https://tvf90.com/5.php?stream=winsports',
      logo: 'https://i.imgur.com/XSL1gd7.png',
      group: 'DEPORTES',
    ),
  ];

  Channel? _currentChannel;
  bool _isLoading = true;
  String _errorMessage = '';

  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  Player? _player; // Web: media_kit (soporta HLS)
  VideoController? _videoController;

  ViewMode _viewMode = ViewMode.mobile;
  bool _showSettings = false;
  bool _zoomMode = false;
  bool _showTVFrame = true;
  double _videoZoom = 1.0;
  Timer? _liveMessageTimer;
  bool _oneSignalDialogShown = false;
  String _selectedTab = 'Todos';
  String _searchQuery = '';
  bool _isFullscreen = false;
  Set<String> _favoriteUrls = {};
  bool _isRecording = false;
  int _recordSeconds = 0;
  Timer? _recordTimer;
  double _volume = 1.0;

  // Controladores de foco para TV Box / Android TV
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _playerFocusNode = FocusNode();

  List<String> get _channelGroups {
    final groups = channels.map((c) => c.group).toSet().toList();
    return ['Todos', ...groups];
  }

  List<Channel> get _filteredChannels {
    var list = channels;
    if (_selectedTab != 'Todos') {
      list = list.where((c) => c.group == _selectedTab).toList();
    }
    if (_searchQuery.isNotEmpty) {
      list = list
          .where((c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return list;
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('favoriteUrls') ?? [];
      if (mounted) {
        setState(() => _favoriteUrls = list.toSet());
      }
    } catch (_) {}
  }

  void _toggleFavorite(Channel c) {
    setState(() {
      if (_favoriteUrls.contains(c.url)) {
        _favoriteUrls.remove(c.url);
      } else {
        _favoriteUrls.add(c.url);
      }
    });
    SharedPreferences.getInstance()
        .then((p) => p.setStringList('favoriteUrls', _favoriteUrls.toList()));
  }

  void _setVolume(double v) {
    setState(() {
      _volume = v.clamp(0.0, 1.0);
    });
    // video_player usa 0.0-1.0; media_kit usa 0.0-100.0.
    _videoPlayerController?.setVolume(_volume);
    _player?.setVolume(_volume * 100);
  }

  void _toggleRecord() {
    if (_isRecording) {
      _recordTimer?.cancel();
      setState(() {
        _isRecording = false;
        _recordSeconds = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Grabación guardada')),
      );
    } else {
      setState(() {
        _isRecording = true;
        _recordSeconds = 0;
      });
      _recordTimer?.cancel();
      _recordTimer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!mounted) return;
        setState(() => _recordSeconds++);
        if (_recordSeconds >= 30) {
          t.cancel();
          setState(() => _isRecording = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Grabación de 30 segundos completada')),
          );
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _currentChannel = channels[0];
    _loadPreferences();
    _loadFavorites();
    _extractAndPlay(_currentChannel!.url);
    WakelockPlus.enable(); // Mantener pantalla encendida
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkRemoteConfig());
    // Revisa mensajes nuevos mientras la app está abierta (en vivo).
    _liveMessageTimer = Timer.periodic(
      const Duration(seconds: 45),
      (_) => _checkLiveMessage(),
    );
    _setupOneSignalObserver();
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

  /// Registra un observador de suscripción de OneSignal y muestra el diálogo
  /// de verificación cuando el dispositivo queda registrado.
  void _setupOneSignalObserver() {
    final service = OneSignalService.instance;
    service.addSubscriptionObserver((id) {
      _maybeShowOneSignalDialog(id);
    });
    // El id puede haberse asignado antes de registrar el observador.
    _maybeShowOneSignalDialog(service.subscriptionId);
  }

  void _maybeShowOneSignalDialog(String? subscriptionId) {
    if (_oneSignalDialogShown ||
        !OneSignalService.instance.isRegistered(subscriptionId)) {
      return;
    }
    _oneSignalDialogShown = true;
    if (!mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Your OneSignal SDK integration is complete!'),
        content: const Text(
          'You can now send Push Notifications & In-App Messages through OneSignal. Tap below to enable push notifications.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              OneSignalService.instance.requestPermission();
            },
            child: const Text('Got it'),
          ),
        ],
      ),
    );
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

  /// Revisa periódicamente si hay un mensaje nuevo y lo muestra como banner
  /// sin interrumpir la reproducción.
  Future<void> _checkLiveMessage() async {
    final config = await UpdateService.fetchConfig();
    if (config == null || !mounted || !config.hasMessage) return;
    if (config.messageId == null) return; // sin id, no se muestra en vivo

    final prefs = await SharedPreferences.getInstance();
    final seenId = prefs.getString('seenMessageId');
    if (config.messageId == seenId) return;

    await prefs.setString('seenMessageId', config.messageId!);
    if (!mounted) return;
    _showLiveBanner(config);
  }

  void _showLiveBanner(RemoteConfig config) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 7),
        backgroundColor: const Color(0xFF16161f),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFEC4899), width: 1),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              config.messageTitle ?? 'TV ANTO',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFEC4899),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              config.messageBody ?? '',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        action: (config.messageUrl != null && config.messageUrl!.isNotEmpty)
            ? SnackBarAction(
                label: 'Ver',
                textColor: const Color(0xFFFBBF24),
                onPressed: () => _openUrl(config.messageUrl!),
              )
            : null,
      ),
    );
  }

  @override
  void dispose() {
    _liveMessageTimer?.cancel();
    _player?.dispose();
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

      if (kIsWeb) {
        // En web, el stream HLS se carga a través del proxy (evita CORS/redirects).
        _initPlayer();
        final proxied = '/api/proxy?url=${Uri.encodeComponent(m3u8Url)}';
        await _player!.open(Media(proxied));
      } else {
        // Android/iOS: video_player + chewie (estable).
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
      }

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

  /// Crea el reproductor web (media_kit) una sola vez y escucha errores.
  void _initPlayer() {
    if (_player != null) return;
    _player = Player();
    _videoController = VideoController(_player!);
    _player!.stream.error.listen((error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = error;
        });
      }
    });
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
    if (_isFullscreen) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            _buildVideoPlayer(),
            Positioned(
              top: 8,
              right: 8,
              child: Row(
                children: [
                  _buildModeSwitcher(),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Salir de pantalla completa',
                    icon: const Icon(Icons.fullscreen_exit, color: Colors.white),
                    onPressed: () => setState(() => _isFullscreen = false),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(isDesktop),
            Expanded(
              child: isDesktop
                  ? Row(
                      children: [
                        SizedBox(width: 320, child: _buildChannelPanel()),
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(child: _buildVideoArea()),
                              _buildProgramInfo(),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(child: _buildVideoArea()),
                        _buildMobileChannelBar(),
                        _buildProgramInfo(),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ====== INTERFAZ MODERNA (TV Box / Web) ======

  Widget _buildBrandLogo() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        gradient: AppTheme.brandGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: [
          AppTheme.shadowSmall,
          BoxShadow(
            color: AppTheme.primaryPink.withValues(alpha: 0.3),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        child: Image.asset(
          'assets/img/logo.jpg',
          height: 48,
          width: 48,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Icon(
                Icons.live_tv_rounded,
                size: 32,
                color: AppTheme.textOnPrimary,
              ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      width: 240,
      height: 48,
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusRound),
        border: Border.all(
          color: AppTheme.borderSubtle,
          width: 0.5,
        ),
        boxShadow: [
          AppTheme.shadowSmall,
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMD),
      child: Row(
        children: [
          Icon(
            Icons.search,
            size: 20,
            color: AppTheme.textMuted,
          ),
          const SizedBox(width: AppTheme.spaceXS),
          Expanded(
            child: TextField(
              focusNode: _searchFocusNode,
              onChanged: (v) => setState(() => _searchQuery = v),
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textPrimary,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Buscar canal...',
                hintStyle: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textDisabled,
                ),
                isDense: true,
              ),
              cursorColor: AppTheme.primaryPink,
            ),
          ),
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              iconSize: 20,
              color: AppTheme.textMuted,
              onPressed: () {
                setState(() => _searchQuery = '');
                _searchFocusNode.requestFocus();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTopBar(bool isDesktop) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceLG),
      decoration: BoxDecoration(
        gradient: AppTheme.surfaceGradient,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.borderSubtle,
            width: 0.5,
          ),
        ),
        boxShadow: [
          AppTheme.shadowSmall,
        ],
      ),
      child: Row(
        children: [
          // Logo principal con animación y brillo
          _buildBrandLogo(),
          const SizedBox(width: AppTheme.spaceMD),
          // Título y subtítulo
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => AppTheme.brandGradient.createShader(bounds),
                child: Text(
                  'TV ANTO',
                  style: AppTheme.headlineSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                'Señal Digital UHD 4K  •  En Vivo',
                style: AppTheme.labelSmall.copyWith(
                  color: AppTheme.accentGreen,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (isDesktop) ...[
            // Búsqueda moderna
            _buildSearchField(),
            const SizedBox(width: AppTheme.spaceMD),
          ],
          _buildModeSwitcher(),
        ],
      ),
    );
  }

  Widget _buildVideoArea() {
    return Stack(
      children: [
        _buildVideoPlayer(),
        if (_currentChannel != null && !_isLoading && _errorMessage.isEmpty)
          Positioned(top: 12, left: 16, child: _buildChannelOverlay()),
        if (_isRecording)
          Positioned(
            top: 12,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.fiber_manual_record, size: 14, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      'REC ${_recordSeconds}s',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildVolumeControl() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Silenciar',
          icon: Icon(
            _volume == 0 ? Icons.volume_off : Icons.volume_up,
            color: Colors.white,
          ),
          onPressed: () => _setVolume(_volume == 0 ? 1.0 : 0.0),
        ),
        SizedBox(
          width: 70,
          child: Slider(
            value: _volume,
            min: 0.0,
            max: 1.0,
            onChanged: _setVolume,
            activeColor: const Color(0xFFEC4899),
            inactiveColor: Colors.white24,
          ),
        ),
      ],
    );
  }

  Widget _buildChannelPanel() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF0a0a0f), Color(0xFF16161f)]),
        border: Border(right: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                const Text(
                  'GUÍA DE CANALES',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white70, letterSpacing: 1),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('● En Vivo', style: TextStyle(fontSize: 11, color: Color(0xFF10B981))),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _channelGroups
                  .map((g) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildTabChip(g),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: _buildChannelList()),
        ],
      ),
    );
  }

  Widget _buildTabChip(String group) {
    final selected = _selectedTab == group;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = group),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: selected ? const LinearGradient(colors: [Color(0xFFEC4899), Color(0xFFFBBF24)]) : null,
          color: selected ? null : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          group,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.black : Colors.white70,
          ),
        ),
      ),
    );
  }

  Widget _buildChannelList() {
    final list = _filteredChannels;
    if (list.isEmpty) {
      return const Center(
        child: Text('Sin canales', style: TextStyle(color: Colors.white54)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final c = list[index];
        final isSelected = _currentChannel?.url == c.url;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: GestureDetector(
            onTap: () => _changeChannel(c),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: isSelected ? const LinearGradient(colors: [Color(0xFFEC4899), Color(0xFFFBBF24)]) : null,
                color: isSelected ? null : Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSelected ? Colors.white : Colors.transparent, width: 1.5),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.network(
                      c.logo,
                      errorBuilder: (_, __, ___) => const Icon(Icons.live_tv, color: Colors.white, size: 22),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.name,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isSelected ? Colors.black : Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          c.group,
                          style: TextStyle(fontSize: 10, color: isSelected ? Colors.black54 : Colors.white54),
                        ),
                      ],
                    ),
                  ),
                  if (_favoriteUrls.contains(c.url)) const Icon(Icons.favorite, color: Colors.white70, size: 16),
                  if (isSelected) const Icon(Icons.play_circle_fill, color: Colors.black54, size: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChannelOverlay() {
    final c = _currentChannel!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
            child: Image.network(
              c.logo,
              height: 28,
              errorBuilder: (_, __, ___) => const Icon(Icons.live_tv, color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                c.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
              ),
              Row(
                children: [
                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  const Text('EN VIVO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white70)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgramInfo() {
    final c = _currentChannel;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF101018),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Row(
        children: [
          if (c != null) ...[
            Image.network(c.logo, height: 22, errorBuilder: (_, __, ___) => const Icon(Icons.live_tv, size: 20)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
                const Text('Transmisión en vivo', style: TextStyle(fontSize: 11, color: Colors.white54)),
              ],
            ),
          ],
          const Spacer(),
          if (c != null)
            GestureDetector(
              onTap: () => _toggleFavorite(c),
              child: _buildActionChip(
                _favoriteUrls.contains(c.url) ? Icons.favorite : Icons.favorite_border,
                'Favorito',
                active: _favoriteUrls.contains(c.url),
              ),
            ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _toggleRecord,
            child: _buildActionChip(
              _isRecording ? Icons.stop : Icons.fiber_manual_record,
              _isRecording ? 'REC ${_recordSeconds}s' : 'Grabar',
              active: _isRecording,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip(IconData icon, String label, {bool active = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFEC4899) : Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 15, color: active ? Colors.white : Colors.white70),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: active ? Colors.white : Colors.white70),
          ),
        ],
      ),
    );
  }

  /// Barra horizontal de canales para móvil (pantallas estrechas).
  Widget _buildMobileChannelBar() {
    final list = _filteredChannels;
    return Container(
      height: 96,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black.withOpacity(0.85), Colors.black.withOpacity(0.6)],
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          final c = list[index];
          final isSelected = _currentChannel?.url == c.url;
          return GestureDetector(
            onTap: () => _changeChannel(c),
            child: Container(
              width: 120,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                gradient: isSelected ? const LinearGradient(colors: [Color(0xFFEC4899), Color(0xFFFBBF24)]) : null,
                color: isSelected ? null : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isSelected ? Colors.white : Colors.transparent, width: 1.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    c.logo,
                    height: 34,
                    errorBuilder: (_, __, ___) => const Icon(Icons.live_tv, size: 30),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    c.name,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
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
    } else if (kIsWeb && _videoController != null) {
      videoWidget = Transform.scale(
        scale: _videoZoom,
        child: Video(
          controller: _videoController!,
          fit: BoxFit.contain,
          controls: NoVideoControls,
        ),
      );
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

          // Control por mando TV Box / Android TV:
          // Permite cambiar canal con Flecha Izquierda / Flecha Derecha y
          // abrir/cerrar configuración con OK / Enter / Espacio.
          Focus(
            autofocus: true,
            onKeyEvent: (node, event) {
              if (event is KeyDownEvent) {
                if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
                  final currentIndex = channels.indexOf(_currentChannel!);
                  if (currentIndex >= 0 && currentIndex < channels.length - 1) {
                    _changeChannel(channels[currentIndex + 1]);
                    return KeyEventResult.handled;
                  }
                } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                  final currentIndex = channels.indexOf(_currentChannel!);
                  if (currentIndex > 0) {
                    _changeChannel(channels[currentIndex - 1]);
                    return KeyEventResult.handled;
                  }
                } else if (event.logicalKey == LogicalKeyboardKey.select ||
                           event.logicalKey == LogicalKeyboardKey.space ||
                           event.logicalKey == LogicalKeyboardKey.enter) {
                  setState(() => _showSettings = !_showSettings);
                  return KeyEventResult.handled;
                }
              }
              return KeyEventResult.ignored;
            },
            child: const SizedBox.shrink(),
          ),

          // Watermark / Marca de agua siempre visible - Estilo moderno y elegante
          if (!_isLoading && _errorMessage.isEmpty && (kIsWeb ? _videoController != null : _chewieController != null))
            Positioned(
              bottom: 100,
              right: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.black.withValues(alpha: 0.5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusRound),
                  border: Border.all(
                    color: AppTheme.primaryPink.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    AppTheme.shadowMedium,
                    BoxShadow(
                      color: AppTheme.primaryPink.withValues(alpha: 0.15),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo con brillo sutil
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                        gradient: AppTheme.brandGradient,
                      ),
                      child: Image.asset(
                        'assets/img/logo.jpg',
                        height: 28,
                        width: 28,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(
                              Icons.live_tv_rounded,
                              size: 22,
                              color: AppTheme.textOnPrimary,
                            ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Texto de marca
                    Text(
                      'TV ANTO',
                      style: AppTheme.labelLarge.copyWith(
                        color: AppTheme.textPrimary,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w800,
                        shadows: [
                          Shadow(
                            color: AppTheme.primaryPink.withValues(alpha: 0.5),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Indicador EN VIVO pulsante
                    _LiveIndicator(),
                  ],
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
                  _buildVolumeControl(),
                  IconButton(
                    tooltip: 'Pantalla completa',
                    icon: const Icon(Icons.fullscreen, color: Colors.white),
                    onPressed: () => setState(() => _isFullscreen = true),
                  ),
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

/// Widget indicador "EN VIVO" con animación de pulso elegante
class _LiveIndicator extends StatefulWidget {
  const _LiveIndicator();

  @override
  State<_LiveIndicator> createState() => _LiveIndicatorState();
}

class _LiveIndicatorState extends State<_LiveIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.accentGreen.withValues(alpha: _animation.value * 0.8),
                AppTheme.accentGreen.withValues(alpha: _animation.value * 0.4),
              ],
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusRound),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentGreen.withValues(alpha: _animation.value * 0.4),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: AppTheme.textOnPrimary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accentGreen.withValues(alpha: _animation.value),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Text(
                'EN VIVO',
                style: AppTheme.labelSmall.copyWith(
                  color: AppTheme.textOnPrimary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
