import 'package:flutter/material.dart';
import 'package:puskeswan_app/components/app_colors.dart';

class AppAntrianHomeCard extends StatelessWidget {
  const AppAntrianHomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          const Text(
            'Antrian Anda',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(70),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    )
                  ],
                  color: AppColors.primary500,
                  borderRadius: const BorderRadius.all(Radius.circular(18))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Antrian Anda",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 12),
                            decoration: const BoxDecoration(
                              color: Color(0xFF6228F0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(999)),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.access_time_filled_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                Text(
                                  "13",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            "dari 25",
                            style: TextStyle(
                                color: AppColors.neutral200,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Text(
                            "Sisa: 5",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "antrian lagi",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.white))),
                        child: TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                minimumSize: const Size(0, 0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 2),
                                tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap),
                            onPressed: () {},
                            child: const Text("Lihat semua antrian", style: TextStyle(fontSize: 12),)),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Antrian Saat Ini",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 12),
                            decoration: const BoxDecoration(
                              color: Color(0xFF6228F0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(999)),
                            ),
                            child: const Row(children: [
                              Icon(
                                Icons.access_time_filled_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                              Text(
                                "8",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            ]),
                          ),
                          const Text(
                            "dari 25",
                            style: TextStyle(
                                color: AppColors.neutral200,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Text(
                            "Jenis Layanan:",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Vaksinasi",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Text(
                            "Dokter:",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                ),
                          ),
                          Text(
                            "drh. Andre",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
