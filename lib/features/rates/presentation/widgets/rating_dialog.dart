import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/enums/rating_type.dart';
import '../bloc/rating_bloc.dart';

class RatingDialog extends StatefulWidget {
  final int? rateableId;
  final RatingForType rateableType;

  const RatingDialog({
    super.key,
    this.rateableId,
    required this.rateableType,
  });

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _rating = 0;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RatingBloc, RatingState>(
      listener: (context, state) {
        if (state is RatingSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('شكراً لتقييمك!'), backgroundColor: AppColors.success),
          );
          Navigator.of(context).pop();
        } else if (state is RatingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
          );
        }
      },
      child: AlertDialog(
        title: Text(
          'تقييم ${widget.rateableType.label}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('كيف كانت تجربتك؟', textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 40,
                  ),
                  onPressed: () => setState(() => _rating = index + 1),
                );
              }),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'أضف تعليقاً (اختياري)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: _rating == 0
                ? null
                : () {
                    context.read<RatingBloc>().add(
                          CreateRatingRequested(
                            rateableId: widget.rateableId,
                            rateableType: widget.rateableType,
                            rating: _rating,
                            comment: _commentController.text,
                          ),
                        );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('إرسال التقييم'),
          ),
        ],
      ),
    );
  }
}
