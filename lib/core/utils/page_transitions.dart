import 'package:flutter/material.dart';

/// Custom page transitions for the Swirl app
class PageTransitions {
  // Private constructor to prevent instantiation
  PageTransitions._();

  /// Slide transition from right to left
  static Route<T> slideFromRight<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  /// Slide transition from left to right
  static Route<T> slideFromLeft<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  /// Slide transition from bottom to top
  static Route<T> slideFromBottom<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  /// Slide transition from top to bottom
  static Route<T> slideFromTop<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, -1.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  /// Fade transition
  static Route<T> fade<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: curve,
          ),
          child: child,
        );
      },
    );
  }

  /// Scale transition (zoom in/out)
  static Route<T> scale<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    double beginScale = 0.8,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: beginScale, end: 1.0).chain(
          CurveTween(curve: curve),
        );
        final scaleAnimation = animation.drive(tween);

        return ScaleTransition(
          scale: scaleAnimation,
          child: child,
        );
      },
    );
  }

  /// Slide and fade combined transition
  static Route<T> slideAndFade<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    Offset begin = const Offset(1.0, 0.0),
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const end = Offset.zero;
        final slideTween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        final offsetAnimation = animation.drive(slideTween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: curve,
            ),
            child: child,
          ),
        );
      },
    );
  }

  /// Scale and fade combined transition
  static Route<T> scaleAndFade<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    double beginScale = 0.8,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final scaleTween = Tween(begin: beginScale, end: 1.0).chain(
          CurveTween(curve: curve),
        );
        final scaleAnimation = animation.drive(scaleTween);

        return ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: curve,
            ),
            child: child,
          ),
        );
      },
    );
  }

  /// Rotation transition
  static Route<T> rotation<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.easeInOut,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: curve),
        );
        final rotationAnimation = animation.drive(tween);

        return RotationTransition(
          turns: rotationAnimation,
          child: child,
        );
      },
    );
  }

  /// Custom cubic transition (smooth professional animation)
  static Route<T> cubicEase<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 0.05);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        final slideTween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        final offsetAnimation = animation.drive(slideTween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: curve,
            ),
            child: child,
          ),
        );
      },
    );
  }

  /// Material Design-style shared axis transition
  static Route<T> sharedAxis<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
    SharedAxisTransitionType transitionType = SharedAxisTransitionType.horizontal,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        Offset begin;
        switch (transitionType) {
          case SharedAxisTransitionType.horizontal:
            begin = const Offset(0.3, 0.0);
            break;
          case SharedAxisTransitionType.vertical:
            begin = const Offset(0.0, 0.3);
            break;
          case SharedAxisTransitionType.scaled:
            return ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutCubic,
                ),
              ),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
        }

        return SlideTransition(
          position: Tween<Offset>(begin: begin, end: Offset.zero).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            ),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  /// No transition (instant)
  static Route<T> none<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }
}

/// Shared axis transition types
enum SharedAxisTransitionType {
  horizontal,
  vertical,
  scaled,
}

/// Extension methods for easier navigation with transitions
extension NavigatorTransitions on BuildContext {
  /// Push with slide from right transition
  Future<T?> pushSlideFromRight<T>(Widget page) {
    return Navigator.of(this).push<T>(
      PageTransitions.slideFromRight(page),
    );
  }

  /// Push with slide from bottom transition
  Future<T?> pushSlideFromBottom<T>(Widget page) {
    return Navigator.of(this).push<T>(
      PageTransitions.slideFromBottom(page),
    );
  }

  /// Push with fade transition
  Future<T?> pushFade<T>(Widget page) {
    return Navigator.of(this).push<T>(
      PageTransitions.fade(page),
    );
  }

  /// Push with scale and fade transition
  Future<T?> pushScaleAndFade<T>(Widget page) {
    return Navigator.of(this).push<T>(
      PageTransitions.scaleAndFade(page),
    );
  }

  /// Push with cubic ease transition
  Future<T?> pushCubicEase<T>(Widget page) {
    return Navigator.of(this).push<T>(
      PageTransitions.cubicEase(page),
    );
  }

  /// Push with shared axis transition
  Future<T?> pushSharedAxis<T>(
    Widget page, {
    SharedAxisTransitionType transitionType = SharedAxisTransitionType.horizontal,
  }) {
    return Navigator.of(this).push<T>(
      PageTransitions.sharedAxis(page, transitionType: transitionType),
    );
  }

  /// Push replacement with slide from right transition
  Future<T?> pushReplacementSlideFromRight<T, TO>(Widget page, {TO? result}) {
    return Navigator.of(this).pushReplacement<T, TO>(
      PageTransitions.slideFromRight(page),
      result: result,
    );
  }

  /// Push replacement with fade transition
  Future<T?> pushReplacementFade<T, TO>(Widget page, {TO? result}) {
    return Navigator.of(this).pushReplacement<T, TO>(
      PageTransitions.fade(page),
      result: result,
    );
  }
}