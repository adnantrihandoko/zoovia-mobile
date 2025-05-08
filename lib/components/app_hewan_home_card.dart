import 'package:flutter/material.dart';
import 'package:puskeswan_app/components/app_button.dart';
import 'package:puskeswan_app/components/app_colors.dart';

class AppHewanHomeCard extends StatelessWidget {
  const AppHewanHomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 6,
              offset: const Offset(0, 4),
            )
          ],
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(18))),
      width: MediaQuery.sizeOf(context).width,
      height: 140,
      child: Row(
        spacing: 12,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://images.unsplash.com/photo-1592194996308-7b43878e84a6',
            ),
          ),
          Flexible(
            child: Column(
              children: [
                Row(
                  children: [
                    const Text("Milo"),
                    const Spacer(),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: const BoxDecoration(
                        color: AppColors.secondary200,
                        borderRadius: BorderRadius.all(Radius.circular(99)),
                      ),
                      child: const Text("Kucing"),
                    )
                  ],
                ),
                const Row(
                  children: [
                    Text("Ras:"),
                    Text("Persian"),
                    Text("Umur:"),
                    Text("3 Tahun"),
                  ],
                ),
                const Spacer(),
                Flex(
                  direction: Axis.horizontal,
                  spacing: 12,
                  children: [
                    Expanded(
                        flex: 1,
                        child: AppButton(
                          height: 0,
                          outlineBorderColor: AppColors.primary500,
                          backgroundColor: Colors.transparent,
                          textColor: AppColors.primary800,
                          onPressed: () => {},
                          text: "Detail",
                          borderRadius: 6,
                        )),
                    Expanded(
                        flex: 2,
                        child: AppButton(
                          height: 0,
                          onPressed: () => {},
                          text: "Rekam Medis",
                          borderRadius: 6,
                        ))
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
