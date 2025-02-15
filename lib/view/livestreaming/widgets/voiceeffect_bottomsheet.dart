import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class VoiceEffectsBottomSheet extends StatelessWidget {
  final Function(AudioEffectPreset?) onEffectSelected;

  VoiceEffectsBottomSheet({required this.onEffectSelected});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> voiceEffects = [
      {"name": "None", "effect": AudioEffectPreset.audioEffectOff, "icon": Icons.clear},
      {"name": "KTV", "effect": AudioEffectPreset.roomAcousticsKtv, "icon": Icons.music_note},
      {"name": "Concert", "effect": AudioEffectPreset.roomAcousticsChorus, "icon": Icons.mic},
      {"name": "Studio", "effect": AudioEffectPreset.roomAcousticsStudio, "icon": Icons.headset},
      {"name": "Ethereal", "effect": AudioEffectPreset.roomAcousticsEthereal, "icon": Icons.cloud},
      {"name": "3D Voice", "effect": AudioEffectPreset.roomAcoustics3dVoice, "icon": Icons.surround_sound},
      {"name": "Uncle", "effect": AudioEffectPreset.pitchCorrection, "icon": Icons.male},
      {"name": "Reverb", "effect": AudioEffectPreset.roomAcousticsVirtualStereo, "icon": Icons.speaker},
    ];

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "🎤 Voice Effects",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // Number of buttons per row
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemCount: voiceEffects.length,
            itemBuilder: (context, index) {
              final effect = voiceEffects[index];
              return GestureDetector(
                onTap: () {
                  onEffectSelected(effect["effect"]);
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.deepOrange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(effect["icon"], size: 30, color: Colors.white),
                      SizedBox(height: 5),
                      Text(
                        effect["name"],
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 15),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text("Close", style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
