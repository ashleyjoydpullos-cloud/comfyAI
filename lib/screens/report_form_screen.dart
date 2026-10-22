
import 'package:flutter/material.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

enum ReportUiState {
  idle,
  loading,
  success,
  empty,
  error,
}

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  ReportUiState _uiState = ReportUiState.idle;
  String _category = 'Bug / Technical Issue';
  bool _simulateFailure = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _uiState = ReportUiState.loading;
    });

    try {
      // Simulated asynchronous submission.
      await Future<void>.delayed(
        const Duration(seconds: 3),
      );

      if (!mounted) return;

      if (_simulateFailure) {
        throw Exception('Simulated submission failure');
      }

      setState(() {
        _uiState = ReportUiState.success;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _uiState = ReportUiState.error;
      });
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _descriptionController.clear();

    setState(() {
      _category = 'Bug / Technical Issue';
      _uiState = ReportUiState.idle;
      _simulateFailure = false;
    });
  }

  Widget _buildStateMessage({
    required IconData icon,
    required String title,
    required String message,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, size: 42, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentState() {
    switch (_uiState) {
      case ReportUiState.loading:
        return _buildStateMessage(
          icon: Icons.hourglass_top,
          title: 'Submitting report...',
          message: 'Please wait. Processing your simulated request.',
          color: Colors.blue,
        );

      case ReportUiState.success:
        return Column(
          children: [
            _buildStateMessage(
              icon: Icons.check_circle_outline,
              title: 'Submission Successful',
              message:
                  'Your report submission completed. ',
                 
              color: Colors.green,
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Submit Another Report',
              onPressed: _resetForm,
            ),
          ],
        );

      case ReportUiState.empty:
        return Column(
          children: [
            _buildStateMessage(
              icon: Icons.inbox_outlined,
              title: 'No Reports Available',
              message:
                  'There are currently no report records to display.',
              color: Colors.blueGrey,
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Create a Report',
              onPressed: _resetForm,
              outlined: true,
            ),
          ],
        );

      case ReportUiState.error:
        return Column(
          children: [
            _buildStateMessage(
              icon: Icons.error_outline,
              title: 'Submission Failed',
              message:
                  'The simulated request failed. You can retry '
                  'or correct your report.',
              color: Colors.red,
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Retry Submission',
              onPressed: _submitReport,
            ),
            const SizedBox(height: 8),
            AppButton(
              label: 'Edit Report',
              onPressed: () {
                setState(() {
                  _uiState = ReportUiState.idle;
                  _simulateFailure = false;
                });
              },
              outlined: true,
            ),
          ],
        );

      case ReportUiState.idle:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _uiState == ReportUiState.loading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ComfyAI Report Form'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const Icon(
                  Icons.feedback_outlined,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  'Feedback & Issue Report',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tell us about an issue or share your feedback '
                  'about ComfyAI.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                if (_uiState == ReportUiState.idle) ...[
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextField(
                          label: 'Report Title',
                          icon: Icons.title,
                          controller: _titleController,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Please enter a report title.';
                            }
                            if (value.trim().length < 3) {
                              return 'Title must be at least 3 characters.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          initialValue: _category,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Bug / Technical Issue',
                              child: Text('Bug / Technical Issue'),
                            ),
                            DropdownMenuItem(
                              value: 'UI / Design Issue',
                              child: Text('UI / Design Issue'),
                            ),
                            DropdownMenuItem(
                              value: 'Feedback',
                              child: Text('Feedback'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _category = value);
                            }
                          },
                        ),
                        const SizedBox(height: 16),

                        AppTextField(
                          label: 'Description',
                          icon: Icons.description_outlined,
                          controller: _descriptionController,
                          keyboardType: TextInputType.multiline,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Please describe the issue.';
                            }
                            if (value.trim().length < 10) {
                              return 'Please enter at least 10 characters.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text(
                            'Simulate submission failure',
                          ),
                          subtitle: const Text(
                            'For testing the Error and Retry states.',
                          ),
                          value: _simulateFailure,
                          onChanged: (value) {
                            setState(() {
                              _simulateFailure = value ?? false;
                            });
                          },
                          controlAffinity:
                              ListTileControlAffinity.leading,
                        ),
                        const SizedBox(height: 12),

                        AppButton(
                          label: 'Submit Report',
                          onPressed: _submitReport,
                        ),
                        const SizedBox(height: 12),

                        AppButton(
                          label: 'Preview Empty State',
                          outlined: true,
                          onPressed: () {
                            setState(() {
                              _uiState = ReportUiState.empty;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],

                if (isLoading) ...[
                  const SizedBox(height: 12),
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Please wait while your report is processed.',
                    textAlign: TextAlign.center,
                  ),
                ],

                if (_uiState != ReportUiState.idle) ...[
                  const SizedBox(height: 16),
                  _buildCurrentState(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
