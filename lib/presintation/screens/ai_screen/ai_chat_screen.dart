import 'package:discipline/presintation/style/app_text_styles.dart';
import 'package:discipline/presintation/style/containet_style.dart';
import 'package:discipline/presintation/style/main_style.dart';
import 'package:discipline/presintation/style/widgets_style.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../ai/ai_service.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final AIService _ai = AIService();

  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();

  final List<_Message> _messages = [];

  bool _loading = false;
  bool _initialized = false;
  bool _initializingAI = true;

  bool _speechAvailable = false;
  bool _isListening = false;
  bool _isSpeaking = false;

  String? _initError;
  String? _speechLocaleId;
  int? _speakingMessageIndex;

  @override
  void initState() {
    super.initState();

    _initAI();
    _initSpeech();
    _initTts();
  }

  // ===========================================================================
  // AI
  // ===========================================================================

  Future<void> _initAI() async {
    try {
      if (!mounted) return;

      setState(() {
        _initializingAI = true;
        _initError = null;
      });

      debugPrint('Connecting to Hugging Face...');

      await _ai.init();

      if (!mounted) return;

      setState(() {
        _initialized = true;
        _initializingAI = false;
      });

      debugPrint('AI READY');
    } catch (e) {
      debugPrint('AI INIT ERROR: $e');

      if (!mounted) return;

      setState(() {
        _initialized = false;
        _initializingAI = false;
        _initError = e.toString();
      });
    }
  }

  // ===========================================================================
  // SPEECH TO TEXT
  // ===========================================================================

  Future<void> _initSpeech() async {
    try {
      final available = await _speech.initialize(
        onStatus: (status) {
          debugPrint('SPEECH STATUS: $status');

          if (!mounted) return;

          if (status == 'done' || status == 'notListening') {
            setState(() {
              _isListening = false;
            });
          }
        },
        onError: (error) {
          debugPrint('SPEECH ERROR: $error');

          if (!mounted) return;

          setState(() {
            _isListening = false;
          });

          _showSnackBar('Не удалось распознать голос');
        },
      );

      if (!available) {
        debugPrint('Speech recognition unavailable');
        return;
      }

      String? russianLocale;

      final locales = await _speech.locales();

      for (final locale in locales) {
        final localeId = locale.localeId.toLowerCase();

        if (localeId.startsWith('ru')) {
          russianLocale = locale.localeId;
          break;
        }
      }

      if (!mounted) return;

      setState(() {
        _speechAvailable = true;
        _speechLocaleId = russianLocale;
      });

      debugPrint('SPEECH READY: true');
      debugPrint('SPEECH LOCALE: $_speechLocaleId');
    } catch (e) {
      debugPrint('SPEECH INIT ERROR: $e');
    }
  }

  Future<void> _toggleListening() async {
    if (!_speechAvailable) {
      _showSnackBar('Голосовой ввод недоступен');
      return;
    }

    if (_isListening) {
      await _speech.stop();

      if (!mounted) return;

      setState(() {
        _isListening = false;
      });

      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    if (!mounted) return;

    setState(() {
      _isListening = true;
    });

    try {
      await _speech.listen(
        localeId: _speechLocaleId,
        partialResults: true,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        onResult: (SpeechRecognitionResult result) {
          if (!mounted) return;

          setState(() {
            _controller.text = result.recognizedWords;

            _controller.selection = TextSelection.collapsed(
              offset: _controller.text.length,
            );
          });
        },
      );
    } catch (e) {
      debugPrint('SPEECH LISTEN ERROR: $e');

      if (!mounted) return;

      setState(() {
        _isListening = false;
      });
    }
  }

  // ===========================================================================
  // TEXT TO SPEECH
  // ===========================================================================

  Future<void> _initTts() async {
    try {
      await _tts.setLanguage('ru-RU');
      await _tts.setSpeechRate(0.48);
      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);

      await _tts.awaitSpeakCompletion(true);

      _tts.setCompletionHandler(() {
        if (!mounted) return;

        setState(() {
          _isSpeaking = false;
          _speakingMessageIndex = null;
        });
      });

      _tts.setCancelHandler(() {
        if (!mounted) return;

        setState(() {
          _isSpeaking = false;
          _speakingMessageIndex = null;
        });
      });

      _tts.setErrorHandler((message) {
        debugPrint('TTS ERROR: $message');

        if (!mounted) return;

        setState(() {
          _isSpeaking = false;
          _speakingMessageIndex = null;
        });
      });

      debugPrint('TTS READY');
    } catch (e) {
      debugPrint('TTS INIT ERROR: $e');
    }
  }

  Future<void> _toggleSpeak(
      String text,
      int index,
      ) async {
    try {
      if (_isSpeaking && _speakingMessageIndex == index) {
        await _tts.stop();

        if (!mounted) return;

        setState(() {
          _isSpeaking = false;
          _speakingMessageIndex = null;
        });

        return;
      }

      await _tts.stop();

      if (!mounted) return;

      setState(() {
        _isSpeaking = true;
        _speakingMessageIndex = index;
      });

      final cleanText = _cleanTextForSpeech(text);

      await _tts.speak(cleanText);
    } catch (e) {
      debugPrint('TTS SPEAK ERROR: $e');

      if (!mounted) return;

      setState(() {
        _isSpeaking = false;
        _speakingMessageIndex = null;
      });
    }
  }

  String _cleanTextForSpeech(String text) {
    var result = text;

    result = result.replaceAll(
      RegExp(r'```[\s\S]*?```'),
      'Блок кода.',
    );

    result = result.replaceAllMapped(
      RegExp(r'\[([^\]]+)\]\([^)]+\)'),
          (match) => match.group(1) ?? '',
    );

    result = result
        .replaceAll(RegExp(r'#{1,6}\s*'), '')
        .replaceAll('**', '')
        .replaceAll('__', '')
        .replaceAll('*', '')
        .replaceAll('_', '')
        .replaceAll('`', '')
        .replaceAll('---', '')
        .replaceAll('- ', '');

    return result.trim();
  }

  // ===========================================================================
  // CHAT
  // ===========================================================================

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();

    if (text.isEmpty || !_initialized || _loading) {
      return;
    }

    if (_isListening) {
      await _speech.stop();

      if (mounted) {
        setState(() {
          _isListening = false;
        });
      }
    }

    _controller.clear();

    setState(() {
      _messages.add(
        _Message(
          text: text,
          isUser: true,
        ),
      );

      _loading = true;
    });

    _scrollToBottom();

    try {
      final answer = await _ai.ask(text);

      if (!mounted) return;

      setState(() {
        _messages.add(
          _Message(
            text: answer,
            isUser: false,
          ),
        );
      });

      _scrollToBottom();
    } catch (e) {
      debugPrint('AI CHAT ERROR: $e');

      if (!mounted) return;

      setState(() {
        _messages.add(
          _Message(
            text: 'Ошибка AI:\n\n$e',
            isUser: false,
          ),
        );
      });

      _scrollToBottom();
    } finally {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _regenerate(int assistantIndex) async {
    if (_loading) return;

    if (assistantIndex <= 0) return;

    final userIndex = assistantIndex - 1;

    if (!_messages[userIndex].isUser) {
      return;
    }

    final userText = _messages[userIndex].text;

    setState(() {
      _messages.removeAt(assistantIndex);
      _loading = true;
    });

    try {
      final answer = await _ai.ask(userText);

      if (!mounted) return;

      setState(() {
        _messages.insert(
          assistantIndex,
          _Message(
            text: answer,
            isUser: false,
          ),
        );
      });

      _scrollToBottom();
    } catch (e) {
      debugPrint('AI REGENERATE ERROR: $e');

      if (!mounted) return;

      setState(() {
        _messages.insert(
          assistantIndex,
          _Message(
            text: 'Ошибка AI:\n\n$e',
            isUser: false,
          ),
        );
      });
    } finally {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });
    }
  }

  // ===========================================================================
  // ACTIONS
  // ===========================================================================

  Future<void> _copyText(String text) async {
    await Clipboard.setData(
      ClipboardData(text: text),
    );

    _showSnackBar('Скопировано');
  }

  Future<void> _shareText(String text) async {
    await SharePlus.instance.share(
      ShareParams(
        title: 'Discipline AI',
        text: text,
      ),
    );
  }

  Future<void> _openLink(String href) async {
    final uri = Uri.tryParse(href);

    if (uri == null) {
      return;
    }

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      _showSnackBar('Не удалось открыть ссылку');
    }
  }

  Future<void> _clearChat() async {
    await _tts.stop();

    if (!mounted) return;

    setState(() {
      _messages.clear();
      _isSpeaking = false;
      _speakingMessageIndex = null;
    });
  }

  Future<void> _stopSpeaking() async {
    await _tts.stop();

    if (!mounted) return;

    setState(() {
      _isSpeaking = false;
      _speakingMessageIndex = null;
    });
  }

  void _showMoreMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: MainStyle.offColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: MainStyle.TextColor.withValues(
                        alpha: 0.15,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 18),

                  ListTile(
                    leading: Icon(
                      Icons.delete_outline,
                      color: MainStyle.dangerColor,
                    ),
                    title: Text(
                      'Очистить чат',
                      style: AppTextStyles.body,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      await _clearChat();
                    },
                  ),

                  ListTile(
                    leading: Icon(
                      Icons.stop_circle_outlined,
                      color: MainStyle.TextColor,
                    ),
                    title: Text(
                      'Остановить озвучку',
                      style: AppTextStyles.body,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      await _stopSpeaking();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    });
  }

  void _showSnackBar(String text) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            text,
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
          backgroundColor: MainStyle.offColor,
        ),
      );
  }

  // ===========================================================================
  // DISPOSE
  // ===========================================================================

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();

    _speech.stop();
    _tts.stop();

    _ai.dispose();

    super.dispose();
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainStyle.backgrountColor,

      appBar: AppBar(
        backgroundColor: MainStyle.backgrountColor,
        elevation: 0,
        titleSpacing: 16,

        title: Row(
          children: [
            Image.asset('assets/images/mini_logo.png', height: 40,),

            const SizedBox(width: 10),

            Text(
              'Discipline AI',
              style: AppTextStyles.heading,
            ),
          ],
        ),

        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: MainStyle.actionColor,
              ),
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: MainStyle.actionColor,
          ),
        )
      ),

      body: Column(
        children: [
          // ===============================================================
          // AI STATUS
          // ===============================================================

          if (_initializingAI)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: ContainerStyle.primaryContainerStyle,
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: MainStyle.actionColor,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      'Подключаем Qwen...',
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 13,
                        color: MainStyle.TextColor.withValues(
                          alpha: 0.70,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // ===============================================================
          // AI ERROR
          // ===============================================================

          if (_initError != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(14),
              decoration: ContainerStyle.redContainerStyle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Не удалось подключить AI',
                    style: AppTextStyles.bodyRed.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    _initError!,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 13,
                      color: MainStyle.TextColor.withValues(
                        alpha: 0.70,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextButton(
                    onPressed: _initAI,
                    child: Text(
                      'Повторить',
                      style: AppTextStyles.ButtonTextStyle.copyWith(
                        color: MainStyle.actionColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // ===============================================================
          // MESSAGES
          // ===============================================================

          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(
                12,
                12,
                12,
                24,
              ),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(
                  _messages[index],
                  index,
                );
              },
            ),
          ),

          // ===============================================================
          // LOADING
          // ===============================================================

          if (_loading)
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: MainStyle.actionColor,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Text(
                    'Qwen думает...',
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 13,
                      color: MainStyle.TextColor.withValues(
                        alpha: 0.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // ===============================================================
          // LISTENING
          // ===============================================================

          if (_isListening)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(
                12,
                0,
                12,
                6,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: MainStyle.offColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: MainStyle.actionColor.withValues(
                    alpha: 0.45,
                  ),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.mic,
                    color: MainStyle.actionColor,
                    size: 18,
                  ),

                  const SizedBox(width: 8),

                  Text(
                    'Слушаю...',
                    style: AppTextStyles.miniGreenText.copyWith(
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),

          // ===============================================================
          // INPUT
          // ===============================================================

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                10,
                6,
                10,
                10,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: MainStyle.offColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: _isListening
                              ? MainStyle.actionColor.withValues(
                            alpha: 0.45,
                          )
                              : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              enabled: _initialized && !_loading,
                              minLines: 1,
                              maxLines: 5,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,

                              style: AppTextStyles.body.copyWith(
                                fontSize: 15,
                              ),

                              cursorColor: MainStyle.actionColor,

                              decoration: InputDecoration(
                                hintText: _initializingAI
                                    ? 'AI подключается...'
                                    : 'Напиши сообщение...',
                                hintStyle: AppTextStyles.hintText,
                                contentPadding:
                                const EdgeInsets.fromLTRB(
                                  18,
                                  13,
                                  8,
                                  13,
                                ),
                                border: InputBorder.none,
                              ),

                              onSubmitted: (_) {
                                _sendMessage();
                              },
                            ),
                          ),

                          IconButton(
                            tooltip: _isListening
                                ? 'Остановить голосовой ввод'
                                : 'Голосовой ввод',

                            onPressed: _initialized && !_loading
                                ? _toggleListening
                                : null,

                            icon: Icon(
                              _isListening
                                  ? Icons.mic
                                  : Icons.mic_none,
                              color: _isListening
                                  ? MainStyle.actionColor
                                  : MainStyle.TextColor.withValues(
                                alpha: 0.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  SizedBox(
                    width: 48,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _initialized && !_loading
                          ? _sendMessage
                          : null,

                      style: WidgetsStyle.primaryButtonStyle.copyWith(
                        minimumSize: const WidgetStatePropertyAll(
                          Size(48, 48),
                        ),
                        padding: const WidgetStatePropertyAll(
                          EdgeInsets.zero,
                        ),
                        shape: const WidgetStatePropertyAll(
                          CircleBorder(),
                        ),
                      ),

                      child: Icon(
                        Icons.arrow_upward_rounded,
                        color: _initialized && !_loading
                            ? MainStyle.backgrountColor
                            : MainStyle.TextColor.withValues(
                          alpha: 0.20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // EMPTY STATE
  // ===========================================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: MainStyle.offColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: MainStyle.actionColor.withValues(
                    alpha: 0.25,
                  ),
                  width: 1,
                ),
              ),
              child: Image.asset('assets/images/mini_logo.png')
            ),

            const SizedBox(height: 18),

            Text(
              'Discipline AI',
              style: AppTextStyles.titleText.copyWith(
                color: MainStyle.TextColor,
                fontSize: 22,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Спроси что-нибудь или\nнажми на микрофон.',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                fontSize: 14,
                color: MainStyle.TextColor.withValues(
                  alpha: 0.38,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // MESSAGE
  // ===========================================================================

  Widget _buildMessage(
      _Message message,
      int index,
      ) {
    final isUser = message.isUser;

    return Align(
      alignment: isUser
          ? Alignment.centerRight
          : Alignment.centerLeft,

      child: Container(
        margin: const EdgeInsets.only(
          bottom: 14,
        ),

        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.90,
        ),

        padding: const EdgeInsets.fromLTRB(
          14,
          12,
          10,
          8,
        ),

        decoration: BoxDecoration(
          color: isUser
              ? MainStyle.actionColor
              : MainStyle.offColor,

          borderRadius: BorderRadius.circular(20),

          border: isUser
              ? null
              : Border.all(
            color: Colors.white12,
            width: 1,
          ),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isUser)
              Text(
                message.text,
                style: AppTextStyles.body.copyWith(
                  color: MainStyle.backgrountColor,
                  fontSize: 15,
                ),
              )
            else
              MarkdownBody(
                data: message.text,
                selectable: true,
                softLineBreak: true,

                onTapLink: (
                    String text,
                    String? href,
                    String title,
                    ) {
                  if (href != null) {
                    _openLink(href);
                  }
                },

                styleSheet: MarkdownStyleSheet.fromTheme(
                  Theme.of(context),
                ).copyWith(
                  p: AppTextStyles.body.copyWith(
                    fontSize: 15,
                    height: 1.45,
                  ),

                  h1: AppTextStyles.display.copyWith(
                    fontSize: 22,
                  ),

                  h2: AppTextStyles.middleText.copyWith(
                    fontSize: 19,
                  ),

                  h3: AppTextStyles.heading.copyWith(
                    fontSize: 17,
                  ),

                  strong: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                  ),

                  em: AppTextStyles.body.copyWith(
                    color: MainStyle.TextColor.withValues(
                      alpha: 0.70,
                    ),
                  ),

                  code: TextStyle(
                    color: MainStyle.actionColor,
                    fontFamily: 'monospace',
                    fontSize: 13,
                  ),

                  a: TextStyle(
                    color: MainStyle.actionColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

            const SizedBox(height: 4),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _MessageActionButton(
                  tooltip: 'Копировать',
                  icon: Icons.copy_outlined,
                  onPressed: () {
                    _copyText(message.text);
                  },
                  dark: isUser,
                ),

                if (!isUser) ...[
                  _MessageActionButton(
                    tooltip: _isSpeaking &&
                        _speakingMessageIndex == index
                        ? 'Остановить'
                        : 'Озвучить',

                    icon: _isSpeaking &&
                        _speakingMessageIndex == index
                        ? Icons.stop_rounded
                        : Icons.volume_up_outlined,

                    onPressed: () {
                      _toggleSpeak(
                        message.text,
                        index,
                      );
                    },

                    active: _isSpeaking &&
                        _speakingMessageIndex == index,
                  ),

                  _MessageActionButton(
                    tooltip: 'Поделиться',
                    icon: Icons.share_outlined,
                    onPressed: () {
                      _shareText(message.text);
                    },
                  ),

                  _MessageActionButton(
                    tooltip: 'Повторить',
                    icon: Icons.refresh_rounded,
                    onPressed: _loading
                        ? null
                        : () {
                      _regenerate(index);
                    },
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// MESSAGE MODEL
// =============================================================================

class _Message {
  final String text;
  final bool isUser;

  const _Message({
    required this.text,
    required this.isUser,
  });
}

// =============================================================================
// MESSAGE ACTION BUTTON
// =============================================================================

class _MessageActionButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool dark;
  final bool active;

  const _MessageActionButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.dark = false,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final inactiveColor = dark
        ? MainStyle.backgrountColor.withValues(
      alpha: 0.25,
    )
        : MainStyle.TextColor.withValues(
      alpha: 0.25,
    );

    final normalColor = dark
        ? MainStyle.backgrountColor.withValues(
      alpha: 0.55,
    )
        : MainStyle.TextColor.withValues(
      alpha: 0.45,
    );

    return IconButton(
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 34,
        minHeight: 34,
      ),
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 18,
        color: onPressed == null
            ? inactiveColor
            : active
            ? MainStyle.actionColor
            : normalColor,
      ),
    );
  }
}