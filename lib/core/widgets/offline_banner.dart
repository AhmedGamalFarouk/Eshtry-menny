import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../network/network_monitor_cubit.dart';

class OfflineBanner extends StatefulWidget {
  const OfflineBanner({super.key});

  @override
  State<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends State<OfflineBanner> {
  bool _showBackOnline = false;
  bool _wasDisconnected = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<NetworkMonitorCubit, NetworkStatus>(
      listener: (context, status) {
        if (status == NetworkStatus.disconnected) {
          setState(() {
            _wasDisconnected = true;
            _showBackOnline = false;
          });
        } else if (status == NetworkStatus.connected && _wasDisconnected) {
          setState(() {
            _showBackOnline = true;
          });
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              setState(() {
                _showBackOnline = false;
                _wasDisconnected = false;
              });
            }
          });
        }
      },
      child: BlocBuilder<NetworkMonitorCubit, NetworkStatus>(
        builder: (context, status) {
          final isDisconnected = status == NetworkStatus.disconnected;
          final isVisible = isDisconnected || _showBackOnline;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isVisible ? 36.0 : 0.0,
            color: isDisconnected ? Colors.orange.shade800 : Colors.green.shade700,
            child: isVisible
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isDisconnected
                            ? Icons.wifi_off_rounded
                            : Icons.wifi_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isDisconnected
                            ? 'No internet connection — working offline'
                            : 'Back online',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
