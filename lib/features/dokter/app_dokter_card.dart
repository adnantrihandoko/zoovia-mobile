// lib/features/dokter/presentation/widgets/dokter_card.dart
import 'package:flutter/material.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/features/dokter/dokter_model.dart';

class DokterCard extends StatelessWidget {
  final DokterModel dokter;
  final VoidCallback? onTap;

  const DokterCard({
    Key? key, 
    required this.dokter, 
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Doctor photo
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: dokter.fotoDokter != null
                    ? Image.network(
                        dokter.fotoDokter!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildDefaultImage(),
                      )
                    : _buildDefaultImage(),
              ),
              const SizedBox(width: 16),
              
              // Doctor information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dokter.namaDokter,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (dokter.layanan != null)
                      Text(
                        "Layanan: ${dokter.layanan!.namaLayanan}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Lihat Profil',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Arrow icon
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultImage() {
    return Container(
      width: 80,
      height: 80,
      color: AppColors.neutral200,
      child: Icon(Icons.person, size: 40, color: Colors.grey[400]),
    );
  }
}