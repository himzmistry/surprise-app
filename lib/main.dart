import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const ProposalApp());
}

class ProposalApp extends StatelessWidget {
  const ProposalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'A Special Message',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFE8B4B8),
        scaffoldBackgroundColor: const Color(0xFFFFF5F7),
      ),
      home: const ProposalHomePage(),
    );
  }
}

class ProposalHomePage extends StatefulWidget {
  const ProposalHomePage({Key? key}) : super(key: key);

  @override
  State<ProposalHomePage> createState() => _ProposalHomePageState();
}

class _ProposalHomePageState extends State<ProposalHomePage>
    with TickerProviderStateMixin {
  int solvedPuzzles = 0;
  bool showFinalProposal = false;
  late AnimationController _starsController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // For teasing buttons
  int buttonClickAttempts = 0;
  bool canClickButton = false;
  double button1OffsetX = 0;
  double button1OffsetY = 0;
  double button2OffsetX = 0;
  double button2OffsetY = 0;

  // ⭐ CUSTOMIZE THESE PUZZLES WITH YOUR OWN QUESTIONS! ⭐
  final List<PuzzleData> puzzles = [
    PuzzleData(
      question: "When did we first clicked?",
      hint: "Think about that special day/ride...",
      answers: ["Luxury Ride", "Marriage", "Home", "Family Function"],
    ),
    PuzzleData(
      question: "What's our favorite place together?",
      hint: "Where we love to spend time",
      answers: ["Udaipur", "Beach", "Mountain", "our spot", "Ahmedabad","Ghat"],
    ),
    PuzzleData(
      question: "Complete: You are my ___",
      hint: "How I feel about you",
      answers: ["everything", "world", "life", "love", "soulmate", "heart"],
    ),
    PuzzleData(
      question: "What do I love most about you?",
      hint: "Think of what I always say",
      answers: ["smile", "laugh", "eyes", "heart", "everything", "you", "Black spot"],
    ),
  ];

  List<bool> solvedStatus = [];
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    solvedStatus = List.filled(puzzles.length, false);
    controllers = List.generate(
      puzzles.length,
          (index) => TextEditingController(),
    );

    _starsController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _starsController.dispose();
    _fadeController.dispose();
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void checkAnswer(int index) {
    String answer = controllers[index].text.toLowerCase().trim();
    if (puzzles[index].answers.any((a) => answer.toLowerCase().contains(a.toLowerCase()))) {
      setState(() {
        if (!solvedStatus[index]) {
          solvedStatus[index] = true;
          solvedPuzzles++;
          if (solvedPuzzles == puzzles.length) {
            Future.delayed(const Duration(milliseconds: 800), () {
              setState(() {
                showFinalProposal = true;
              });
            });
          }
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✨ Correct! One step closer...',
              style: TextStyle(fontSize: 16)),
          backgroundColor: Color(0xFFE8B4B8),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not quite... Try again! 💭',
              style: TextStyle(fontSize: 16)),
          backgroundColor: Color(0xFFC98EA7),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void onButtonHover(int buttonIndex) {
    if (canClickButton) return;

    final random = math.Random();
    setState(() {
      buttonClickAttempts++;

      if (buttonClickAttempts >= 5) {
        canClickButton = true;
        button1OffsetX = 0;
        button1OffsetY = 0;
        button2OffsetX = 0;
        button2OffsetY = 0;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Yayyyyyy!!! Now Click 😄💕',
                style: TextStyle(fontSize: 16)),
            backgroundColor: Color(0xFFE8B4B8),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // Move the button randomly
      double newX = (random.nextDouble() - 0.5) * 100;
      double newY = (random.nextDouble() - 0.5) * 80;

      if (buttonIndex == 1) {
        button1OffsetX = newX;
        button1OffsetY = newY;
      } else {
        button2OffsetX = newX;
        button2OffsetY = newY;
      }

      // Show teasing messages
      List<String> teasingMessages = [
        'Aklu jaldi thodi! 😏',
        'Nenenenenenen! 😜',
        'Bucchie kare to j! 😆',
        'Areyy karr boo badhiii! 🤭',
        'Yayyyyyy! 😝',
      ];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            teasingMessages[buttonClickAttempts - 1],
            style: const TextStyle(fontSize: 16),
          ),
          backgroundColor: const Color(0xFFC98EA7),
          duration: const Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: Container(
        decoration: showFinalProposal ? const BoxDecoration(
          image: DecorationImage(
            // Use AssetImage for local images
            image: AssetImage('assets/bg.png'),
            fit: BoxFit.cover, // Adjusts the image to cover the entire container
          ),
        ): null,
        child: Stack(
          children: [
            // Animated background with stars
            AnimatedBackground(controller: _starsController),

            // Main content
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                          if (!showFinalProposal) ...[
                            _buildHeader(),
                            const SizedBox(height: 30),
                            _buildProgressBar(),
                            const SizedBox(height: 40),
                            _buildPuzzleGrid(),
                          ] else ...[
                          Align(alignment: Alignment.centerRight, child: _buildFinalProposal()),
                        ],
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 1200),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Text(
            'A Journey of Love',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width < 600 ? 36 : 48,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFC98EA7),
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 1500),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: child,
            );
          },
          child: const Text(
            'Solve these puzzles to unlock\na special message just for you',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF5A5A5A),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    double progress = solvedPuzzles / puzzles.length;
    return Column(
      children: [
        Text(
          '$solvedPuzzles / ${puzzles.length} Solved',
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFFC98EA7),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 12,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFE8B4B8).withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE8B4B8), Color(0xFFC98EA7)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPuzzleGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool thresholdWidth = constraints.maxWidth > 600;
        int crossAxisCount = thresholdWidth ? 2 : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio:thresholdWidth ?  7/3 : 0.95,
          ),
          itemCount: puzzles.length,
          itemBuilder: (context, index) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.1, end: 1.0),
              duration: Duration(milliseconds: 600 + (index * 200)),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value,
                    child: child,
                  ),
                );
              },
              child: _buildPuzzlePiece(index),
            );
          },
        );
      },
    );
  }

  Widget _buildPuzzlePiece(int index) {
    bool isSolved = solvedStatus[index];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      decoration: BoxDecoration(
        gradient: isSolved
            ? const LinearGradient(
          colors: [Colors.pink, Colors.red,],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : null,
        color: isSolved ? null : Color(0xff3C1F2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSolved
              ? const Color(0xFFC98EA7)
              : Colors.transparent,
          width: 3,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSolved
                        ? Colors.white.withOpacity(0.3)
                        : const Color(0xFFE8B4B8).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isSolved ? Icons.check_circle : Icons.lock,
                    color: isSolved ? Colors.white : const Color(0xFFC98EA7),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Puzzle ${index + 1}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSolved ? Colors.white : const Color(0xFFC98EA7),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              puzzles[index].question,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isSolved ? Colors.white : const Color(0xFF5A5A5A),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              puzzles[index].hint,
              style: TextStyle(
                fontSize: 15,
                color: isSolved
                    ? Colors.white.withOpacity(0.9)
                    : const Color(0xFF5A5A5A).withOpacity(0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
            const Spacer(),
            if (!isSolved) ...[
              TextField(
                controller: controllers[index],
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Your answer...',
                  filled: true,
                  fillColor: const Color(0xFFFFF5F7),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFE8B4B8),
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFE8B4B8),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFC98EA7),
                      width: 2,
                    ),
                  ),
                ),
                onSubmitted: (_) => checkAnswer(index),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => checkAnswer(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE8B4B8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Check Answer',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Solved!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFinalProposal() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0), // FIX: Clamp the value
          child: Transform.scale(
            scale: 0.8 + (0.2 * value),
            child: child,
          ),
        );
      },
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE8B4B8), Color(0xFFD4A0AA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3E2447).withOpacity(0.4),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          children: [
            const HeartbeatIcon(),
            const SizedBox(height: 30),
            const Text(
              'You Did It!',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Text(
                      'Will You Marry Me?',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC98EA7),
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Every puzzle led to this moment.\nEvery memory brought us here.\nYou are my answer to everything.\n\nI love you more than words can say.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF5A5A5A),
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: _buildTeasingButton('YES! 💍', 1),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildTeasingButton('Of course! 💕', 2),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeasingButton(String text, int buttonIndex) {
    double offsetX = buttonIndex == 1 ? button1OffsetX : button2OffsetX;
    double offsetY = buttonIndex == 1 ? button1OffsetY : button2OffsetY;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transform: Matrix4.translationValues(offsetX, offsetY, 0),
      child: MouseRegion(
        onEnter: (_) => onButtonHover(buttonIndex),
        child: GestureDetector(
          onTap: canClickButton
              ? () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 800),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: child,
                          );
                        },
                        child: const Icon(
                          Icons.favorite,
                          size: 80,
                          color: Color(0xFFE8B4B8),
                        ),
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        'I love you! ❤️',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC98EA7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'You just made me the\nhappiest person alive!',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF5A5A5A),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE8B4B8),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Forever & Always 💕',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
              : () => onButtonHover(buttonIndex),
          child: ElevatedButton(
            onPressed: null, // Disabled, using GestureDetector instead
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFC98EA7),
              disabledBackgroundColor: Colors.white,
              disabledForegroundColor: const Color(0xFFC98EA7),
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponseButton(String text) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: const Icon(
                      Icons.favorite,
                      size: 80,
                      color: Color(0xFFD4A574),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'I love you! ❤️',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B6F47),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'You just made me the\nhappiest person alive!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF2C2416),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4A574),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Forever & Always 💕',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF8B6F47),
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Puzzle data model
class PuzzleData {
  final String question;
  final String hint;
  final List<String> answers;

  PuzzleData({
    required this.question,
    required this.hint,
    required this.answers,
  });
}

// Animated background with twinkling stars
class AnimatedBackground extends StatelessWidget {
  final AnimationController controller;

  const AnimatedBackground({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height,
          ),
          painter: StarsPainter(controller.value),
        );
      },
    );
  }
}

// Stars painter for background
class StarsPainter extends CustomPainter {
  final double animationValue;

  StarsPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE8B4B8).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final random = math.Random(42);
    for (int i = 0; i < 150; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final phase = (animationValue + random.nextDouble()) % 1.0;
      final opacity = (math.sin(phase * 2 * math.pi) + 1) / 2;

      paint.color = const Color(0xFFE8B4B8).withOpacity(opacity * 0.5);
      canvas.drawCircle(
        Offset(x, y),
        1.5 + (opacity * 1.5),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Heartbeat animation widget
class HeartbeatIcon extends StatefulWidget {
  const HeartbeatIcon({Key? key}) : super(key: key);

  @override
  State<HeartbeatIcon> createState() => _HeartbeatIconState();
}

class _HeartbeatIconState extends State<HeartbeatIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 60),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: const Icon(
        Icons.favorite,
        size: 80,
        color: Colors.white,
      ),
    );
  }
}