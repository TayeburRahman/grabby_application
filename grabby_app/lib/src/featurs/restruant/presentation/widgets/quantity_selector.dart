import '../../../../src_export.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        _StepButton(
          Icon(Icons.remove, size: 18, color: Colors.grey.shade600),
          onTap: onDecrement,
        ),
        CustomText(
          "$quantity",
          fontSize: ResponsiveTextSizes.getFontSizeDefault(context),
          fontWeight: FontWeight.bold,
        ),
        _StepButton(
          const Icon(Icons.add, size: 18, color: Color(0xFFADA4F8)),
          onTap: onIncrement,
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onTap;

  const _StepButton(this.icon, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ButtonTapWidget(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: icon,
      ),
    );
  }
}
