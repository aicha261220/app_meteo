import 'package:flutter/material.dart';
import 'package:meteo_app/constants/app_constants.dart';
import 'package:meteo_app/constants/strings.dart';

class AnimatedMessage extends StatefulWidget {
  final double fontSize;
  final Color textColor;
  final Duration animationDuration;

  const AnimatedMessage({
    Key? key,
    this.fontSize = 16.0,
    this.textColor = Colors.grey,
    this.animationDuration = AppConstants.messageRotationInterval,
  }) : super(key: key);

  @override
  _AnimatedMessageState createState() => _AnimatedMessageState();
}

class _AnimatedMessageState extends State<AnimatedMessage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  int _currentMessageIndex = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Changer le message toutes les 3 secondes
    _startMessageRotation();
  }

  void _startMessageRotation() {
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _currentMessageIndex = (_currentMessageIndex + 1) % AppStrings.loadingMessages.length;
        });
        _startMessageRotation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0.0, (1 - _fadeAnimation.value) * 10),
            child: child,
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icône de chargement animée
          RotationTransition(
            turns: _controller,
            child: Icon(
              Icons.autorenew,
              size: widget.fontSize + 4,
              color: widget.textColor,
            ),
          ),
          SizedBox(width: 12),
          // Message textuel
          Expanded(
            child: Text(
              AppStrings.loadingMessages[_currentMessageIndex],
              style: TextStyle(
                fontSize: widget.fontSize,
                color: widget.textColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Version alternative avec seulement du texte
  Widget _buildTextOnlyVersion() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axis: Axis.vertical,
            child: child,
          ),
        );
      },
      child: Text(
        AppStrings.loadingMessages[_currentMessageIndex],
        key: ValueKey<int>(_currentMessageIndex),
        style: TextStyle(
          fontSize: widget.fontSize,
          color: widget.textColor,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Version avec indicateur de progression
  Widget _buildWithProgressIndicator() {
    return Column(
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(widget.textColor),
          strokeWidth: 2.0,
        ),
        SizedBox(height: 12),
        Text(
          AppStrings.loadingMessages[_currentMessageIndex],
          style: TextStyle(
            fontSize: widget.fontSize,
            color: widget.textColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}