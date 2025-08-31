import 'package:flutter/material.dart';

class ProgressGauge extends StatefulWidget {
  final double progress;
  final VoidCallback? onComplete;

  const ProgressGauge({Key? key, required this.progress, this.onComplete}) : super(key: key);

  @override
  _ProgressGaugeState createState() => _ProgressGaugeState();
}

class _ProgressGaugeState extends State<ProgressGauge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: widget.progress).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    )..addListener(() {
      setState(() {});
    });

    _controller.forward();
  }

  @override
  void didUpdateWidget(ProgressGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(begin: oldWidget.progress, end: widget.progress).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 200,
          height: 200,
          child: CircularProgressIndicator(
            value: _animation.value,
            strokeWidth: 12,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
        Text(
          '${(_animation.value * 100).toStringAsFixed(0)}%',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        if (widget.progress >= 1.0)
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: widget.onComplete,
                child: Icon(
                  Icons.refresh,
                  size: 40,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
      ],
    );
  }
}