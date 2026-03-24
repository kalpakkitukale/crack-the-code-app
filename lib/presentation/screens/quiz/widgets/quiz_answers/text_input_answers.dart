import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/extensions/context_extensions.dart';
import 'package:crack_the_code/domain/entities/quiz/question.dart';
import 'package:crack_the_code/presentation/providers/user/quiz_provider.dart';

/// Displays a text input field for fill-in-the-blank questions.
class FillInBlankAnswer extends ConsumerWidget {
  final Question question;
  final TextEditingController controller;
  final bool enhanced;

  const FillInBlankAnswer({
    super.key,
    required this.question,
    required this.controller,
    this.enhanced = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      controller: controller,
      onChanged: (value) async {
        if (value.isNotEmpty) {
          await ref.read(quizProvider.notifier).submitAnswer(
                questionId: question.id,
                answer: value,
              );
        }
      },
      style: enhanced ? context.textTheme.bodyLarge : context.textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: 'Type your answer here...',
        prefixIcon: const Icon(Icons.edit),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () async {
                  controller.clear();
                  await ref.read(quizProvider.notifier).clearAnswer(
                        questionId: question.id,
                      );
                },
              )
            : null,
      ),
      textInputAction: TextInputAction.done,
      autofocus: enhanced,
    );
  }
}

/// Displays a numerical input field with number keyboard.
class NumericalAnswer extends ConsumerWidget {
  final Question question;
  final TextEditingController controller;
  final bool enhanced;

  const NumericalAnswer({
    super.key,
    required this.question,
    required this.controller,
    this.enhanced = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      controller: controller,
      onChanged: (value) async {
        if (value.isNotEmpty) {
          await ref.read(quizProvider.notifier).submitAnswer(
                questionId: question.id,
                answer: value,
              );
        }
      },
      style: enhanced ? context.textTheme.bodyLarge : context.textTheme.bodyMedium,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]')),
      ],
      decoration: InputDecoration(
        hintText: 'Enter numerical answer...',
        prefixIcon: const Icon(Icons.calculate),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () async {
                  controller.clear();
                  await ref.read(quizProvider.notifier).clearAnswer(
                        questionId: question.id,
                      );
                },
              )
            : null,
      ),
      textInputAction: TextInputAction.done,
      autofocus: enhanced,
    );
  }
}
