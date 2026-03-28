import 'dart:io';

import 'package:flutter/material.dart';
import 'package:device_identity/device_identity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Device Identity Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DeviceInfoPage(),
    );
  }
}

class DeviceInfoPage extends StatefulWidget {
  const DeviceInfoPage({super.key});

  @override
  State<DeviceInfoPage> createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage> {
  String _androidId = '-';
  String _imei = '-';
  String _oaid = '-';
  String _ua = '-';
  String _idfa = '-';
  String _idfaStatus = '-';

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      DeviceIdentity.register();
    }
  }

  Future<void> _fetchAndroid() async {
    setState(() => _loading = true);
    final results = await Future.wait([
      DeviceIdentity.androidId,
      DeviceIdentity.imei,
      DeviceIdentity.oaid,
      DeviceIdentity.ua,
    ]);
    setState(() {
      _androidId = _display(results[0]);
      _imei = _display(results[1]);
      _oaid = _display(results[2]);
      _ua = _display(results[3]);
      _loading = false;
    });
  }

  Future<void> _requestIosPermission() async {
    setState(() => _loading = true);
    final status = await DeviceIdentity.requestTrackingAuthorization();
    final idfa = await DeviceIdentity.idfa;
    setState(() {
      _idfaStatus = status.name;
      _idfa = _display(idfa);
      _loading = false;
    });
  }

  String _display(String v) => v.isEmpty ? '(空)' : v;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Identity'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (Platform.isAndroid) ...[
                const _SectionHeader('Android 标识符'),
                _InfoCard(label: 'Android ID', value: _androidId),
                const SizedBox(height: 8),
                _InfoCard(label: 'IMEI', value: _imei),
                const SizedBox(height: 8),
                _InfoCard(label: 'OAID / AAID', value: _oaid),
                const SizedBox(height: 8),
                _InfoCard(label: 'User-Agent', value: _ua),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _loading ? null : _fetchAndroid,
                  icon: _loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                  label: Text(_loading ? '获取中...' : '获取所有标识符'),
                ),
              ],
              if (Platform.isIOS) ...[
                const _SectionHeader('iOS 标识符'),
                _InfoCard(label: 'IDFA', value: _idfa),
                const SizedBox(height: 8),
                _InfoCard(label: '授权状态', value: _idfaStatus),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _loading ? null : _requestIosPermission,
                  icon: _loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.policy_outlined),
                  label: Text(_loading ? '请求中...' : '请求追踪权限并获取 IDFA'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 4),
            SelectableText(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
