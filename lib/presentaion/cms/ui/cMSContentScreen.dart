import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import '../../../widget/custom_appBar.dart';
import '../viewModel/cmsPro.dart';

class CMSContentScreen extends StatefulWidget {
  final String title;
  final CMSContentType type;

  const CMSContentScreen({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  State<CMSContentScreen> createState() => _CMSContentScreenState();
}

enum CMSContentType {
  privacy,
  terms,
  refund,
}

class _CMSContentScreenState extends State<CMSContentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CMSProvider>(context, listen: false);
      _loadData(provider);
    });
  }

  void _loadData(CMSProvider provider) {
    switch (widget.type) {
      case CMSContentType.privacy:
        provider.getPrivacyPolicyApi(context: context);
        break;
      case CMSContentType.terms:
        provider.getTermsConditionsApi(context: context);
        break;
      case CMSContentType.refund:
        provider.getRefundPolicyApi(context: context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        isBack: true,
      ),
      body: Consumer<CMSProvider>(
        builder: (context, provider, child) {
          bool isLoading = provider.isLoading;

          dynamic model;
          String? content;

          switch (widget.type) {
            case CMSContentType.privacy:
              model = provider.privacyPolicyModel;
              content = model?.data?.isNotEmpty == true
                  ? model.data!.first.privacyPolicy
                  : null;
              break;
            case CMSContentType.terms:
              model = provider.termConditionsModel;
              content = model?.data?.isNotEmpty == true
                  ? model.data!.first.termCondition
                  : null;
              break;
            case CMSContentType.refund:
              model = provider.refundPrivacyPolicyModel;
              content = model?.data?.isNotEmpty == true
                  ? model.data!.first.refundPolicy
                  : null;
              break;
          }

          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (model == null || model.status != true) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    "Failed to load content",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _loadData(provider),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          if (content == null || content.isEmpty) {
            return const Center(
              child: Text(
                "No content available",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Html(
              data: content,
              style: {
                "body": Style(
                  fontSize: FontSize(16),
                  lineHeight: LineHeight(1.6),
                  color: Colors.black87,
                ),
                "h1": Style(fontSize: FontSize(24), fontWeight: FontWeight.bold),
                "h2": Style(fontSize: FontSize(20), fontWeight: FontWeight.w600),
                "p": Style(margin: Margins.symmetric(vertical: 8)),
                "ul": Style(margin: Margins.symmetric(vertical: 8)),
                "li": Style(margin: Margins.only(bottom: 6)),
                "a": Style(color: Colors.blue),
              },
              onLinkTap: (url, _, __) {
                // Optional: open link in browser
                // launchUrl(Uri.parse(url ?? ''));
                debugPrint("Link tapped: $url");
              },
            ),
          );
        },
      ),
    );
  }
}