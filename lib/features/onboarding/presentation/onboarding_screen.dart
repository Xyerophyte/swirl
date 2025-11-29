import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swirl/features/home/providers/feed_provider.dart';
import '../services/onboarding_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _showOnboardingModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OnboardingModal(
        onComplete: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed('/home');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 600;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: isSmallScreen ? 20 : 40),
                        
                        // Logo (full, not rounded, fixed - no animation)
                        Flexible(
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: isSmallScreen ? 150 : 200,
                            height: isSmallScreen ? 150 : 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                        
                        SizedBox(height: isSmallScreen ? 40 : 80),
                        
                        // Get Started Button - Beautiful with animated black outline
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: AnimatedBuilder(
                            animation: Listenable.merge([_rotationController, _pulseController]),
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _isPressed ? 0.95 : (1.0 + (_pulseController.value * 0.05)),
                                child: GestureDetector(
                                  onTapDown: (_) => setState(() => _isPressed = true),
                                  onTapUp: (_) {
                                    setState(() => _isPressed = false);
                                    _showOnboardingModal();
                                  },
                                  onTapCancel: () => setState(() => _isPressed = false),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(34),
                                      gradient: SweepGradient(
                                        colors: [
                                          Colors.black,
                                          Colors.black.withOpacity(0.3),
                                          Colors.black,
                                          Colors.black.withOpacity(0.3),
                                          Colors.black,
                                        ],
                                        stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                                        transform: GradientRotation(_rotationController.value * 2 * 3.14159),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 20,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      constraints: const BoxConstraints(maxWidth: 400),
                                      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 14 : 18),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Get Started',
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 16 : 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 600.ms, duration: 800.ms)
                            .slideY(begin: 0.2, end: 0, delay: 600.ms),
                        
                        SizedBox(height: isSmallScreen ? 20 : 40),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class RotatingBorderPainter extends CustomPainter {
  final double rotation;
  final Color color;

  RotatingBorderPainter({required this.rotation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = SweepGradient(
        colors: [
          color,
          color.withOpacity(0.1),
          color,
        ],
        stops: const [0.0, 0.5, 1.0],
        transform: GradientRotation(rotation),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    final rrect = RRect.fromRectAndRadius(
      rect.deflate(1.75),
      const Radius.circular(30),
    );
    
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(RotatingBorderPainter oldDelegate) => rotation != oldDelegate.rotation;
}

class OnboardingModal extends ConsumerStatefulWidget {
  final VoidCallback onComplete;

  const OnboardingModal({super.key, required this.onComplete});

  @override
  ConsumerState<OnboardingModal> createState() => _OnboardingModalState();
}

class _OnboardingModalState extends ConsumerState<OnboardingModal> {
  int _currentStep = 0;
  String? _selectedGender;
  final Set<String> _selectedStyles = {};
  String? _selectedPriceTier;
  bool _isLoading = false;

  Future<void> _completeOnboarding() async {
    if (_selectedGender == null || _selectedStyles.isEmpty || _selectedPriceTier == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all preferences')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await OnboardingService.createTemporaryUser(
        gender: _selectedGender!,
        styles: _selectedStyles.toList(),
        priceTier: _selectedPriceTier!,
      );

      await OnboardingService.setOnboardingComplete();
      ref.read(feedProvider.notifier).loadInitialFeed();

      if (mounted) {
        widget.onComplete();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  bool get _canProceed {
    switch (_currentStep) {
      case 0:
        return _selectedGender != null;
      case 1:
        return _selectedStyles.isNotEmpty;
      case 2:
        return _selectedPriceTier != null;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Progress indicator
            _buildProgressIndicator(),
            
            // Content
            Expanded(
              child: IndexedStack(
                index: _currentStep,
                children: [
                  _buildGenderSelection(),
                  _buildStyleSelection(),
                  _buildPriceSelection(),
                ],
              ),
            ),
            
            // Navigation buttons
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        children: List.generate(3, (index) {
          final isActive = index <= _currentStep;
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
              decoration: BoxDecoration(
                color: isActive ? Colors.black : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            )
                .animate(target: index == _currentStep ? 1 : 0)
                .shimmer(duration: 1000.ms, color: Colors.black),
          );
        }),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.person_outline, color: Colors.black, size: 28),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Who are you shopping for?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildGenderCard('Women', 'women', Icons.woman),
          const SizedBox(height: 16),
          _buildGenderCard('Men', 'men', Icons.man),
          const SizedBox(height: 16),
          _buildGenderCard('Everyone', 'all', Icons.people),
        ],
      ),
    );
  }

  Widget _buildGenderCard(String label, String value, IconData icon) {
    final isSelected = _selectedGender == value;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.black,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.white, size: 24)
                  .animate()
                  .scale(duration: 300.ms, curve: Curves.elasticOut),
          ],
        ),
      ),
    );
  }

  Widget _buildStyleSelection() {
    final styles = [
      {'name': 'Casual', 'icon': Icons.weekend},
      {'name': 'Formal', 'icon': Icons.business_center},
      {'name': 'Streetwear', 'icon': Icons.directions_walk},
      {'name': 'Minimalist', 'icon': Icons.minimize},
      {'name': 'Vintage', 'icon': Icons.history},
      {'name': 'Bohemian', 'icon': Icons.nature_people},
      {'name': 'Sporty', 'icon': Icons.sports},
      {'name': 'Elegant', 'icon': Icons.auto_awesome},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.style, color: Colors.black, size: 28),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'What\'s your style?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_selectedStyles.length} selected',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: styles.map((style) {
              final isSelected = _selectedStyles.contains(style['name']);
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedStyles.remove(style['name']);
                    } else {
                      _selectedStyles.add(style['name'] as String);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Colors.black : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        style['icon'] as IconData,
                        color: isSelected ? Colors.white : Colors.black,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        style['name'] as String,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.check_circle, color: Colors.white, size: 16),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSelection() {
    final priceRanges = [
      {'label': '💸 Entry Luxury', 'subtitle': 'AED 450 - 2,000', 'value': 'budget'},
      {'label': '💰 Mid Luxury', 'subtitle': 'AED 2K - 10K', 'value': 'mid'},
      {'label': '💎 Premium Luxury', 'subtitle': 'AED 10K - 25K', 'value': 'premium'},
      {'label': '👑 Ultra Luxury', 'subtitle': 'AED 25K+', 'value': 'luxury'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.attach_money, color: Colors.black, size: 28),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Your luxury tier?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ...priceRanges.map((range) {
            final isSelected = _selectedPriceTier == range['value'];
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: () => setState(() => _selectedPriceTier = range['value'] as String),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? Colors.black : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: Text(
                          range['label'] as String,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          range['subtitle'] as String,
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected ? Colors.white.withOpacity(0.8) : Colors.grey.shade600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (isSelected)
                        const Icon(Icons.check_circle, color: Colors.white, size: 24)
                            .animate()
                            .scale(duration: 300.ms, curve: Curves.elasticOut),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: GestureDetector(
                onTap: _previousStep,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                  ),
                  child: const Center(
                    child: Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          
          if (_currentStep > 0) const SizedBox(width: 16),
          
          Expanded(
            flex: _currentStep > 0 ? 2 : 1,
            child: GestureDetector(
              onTap: _canProceed
                  ? (_currentStep == 2 ? _completeOnboarding : _nextStep)
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _canProceed ? Colors.black : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentStep == 2 ? 'Start Shopping' : 'Continue',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _canProceed ? Colors.white : Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              _currentStep == 2 ? Icons.shopping_bag : Icons.arrow_forward,
                              color: _canProceed ? Colors.white : Colors.grey.shade600,
                              size: 20,
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}