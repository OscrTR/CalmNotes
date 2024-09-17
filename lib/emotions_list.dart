final lastUse = DateTime.now().toUtc().millisecondsSinceEpoch;

List<Map<String, dynamic>> emotions = [
  {
    'nameEn': 'happy',
    'nameFr': 'heureux',
    'level': 0,
    'basicEmotion': '',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'playful',
    'nameFr': 'enjoué',
    'level': 1,
    'basicEmotion': 'happy',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'aroused',
    'nameFr': 'excité',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'playful',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'cheeky',
    'nameFr': 'effronté',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'playful',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'content',
    'nameFr': 'satisfait',
    'level': 1,
    'basicEmotion': 'happy',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'free',
    'nameFr': 'libre',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'content',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'joyful',
    'nameFr': 'joyeux',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'content',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'interested',
    'nameFr': 'intéressé',
    'level': 1,
    'basicEmotion': 'happy',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'curious',
    'nameFr': 'curieux',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'interested',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'inquisitive',
    'nameFr': 'inquisiteur',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'interested',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'proud',
    'nameFr': 'fier',
    'level': 1,
    'basicEmotion': 'happy',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'successful',
    'nameFr': 'performant',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'proud',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'confident',
    'nameFr': 'confiant',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'proud',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'accepted',
    'nameFr': 'accepté',
    'level': 1,
    'basicEmotion': 'happy',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'respected',
    'nameFr': 'respecté',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'accepted',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'valued',
    'nameFr': 'valorisé',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'accepted',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'powerful',
    'nameFr': 'puissant',
    'level': 1,
    'basicEmotion': 'happy',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'courageous',
    'nameFr': 'courageux',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'powerful',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'creative',
    'nameFr': 'creatif',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'powerful',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'peaceful',
    'nameFr': 'paisible',
    'level': 1,
    'basicEmotion': 'happy',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'loving',
    'nameFr': 'aimant',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'peaceful',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'thankful',
    'nameFr': 'reconaissant',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'peaceful',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'trusting',
    'nameFr': 'confiant',
    'level': 1,
    'basicEmotion': 'happy',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'sensitive',
    'nameFr': 'sensible',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'trusting',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'intimate',
    'nameFr': 'intime',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'trusting',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'optimistic',
    'nameFr': 'optimiste',
    'level': 1,
    'basicEmotion': 'happy',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'hopeful',
    'nameFr': "plein d/'espoir",
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'optimistic',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'inspired',
    'nameFr': 'inspiré',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'optimistic',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'sad',
    'nameFr': 'triste',
    'level': 0,
    'basicEmotion': '',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'lonely',
    'nameFr': 'seul',
    'level': 1,
    'basicEmotion': 'sad',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'abandoned',
    'nameFr': 'abandonné',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'lonely',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'isolated',
    'nameFr': 'isolé',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'lonely',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'vulnerable',
    'nameFr': 'vulnerable',
    'level': 1,
    'basicEmotion': 'sad',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'fragile',
    'nameFr': 'fragile',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'vulnerable',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'victimised',
    'nameFr': 'victimisé',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'vulnerable',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'despair',
    'nameFr': 'désespéré',
    'level': 1,
    'basicEmotion': 'sad',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'powerless',
    'nameFr': 'impuissant',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'despair',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'grief',
    'nameFr': 'chagrin',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'despair',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'guilty',
    'nameFr': 'vulnerable',
    'level': 1,
    'basicEmotion': 'sad',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'ashamed',
    'nameFr': 'honteux',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'guilty',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'remorseful',
    'nameFr': 'plein de remords',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'guilty',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'depressed',
    'nameFr': 'deprimé',
    'level': 1,
    'basicEmotion': 'sad',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'empty',
    'nameFr': 'vide',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'depressed',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'inferior',
    'nameFr': 'inférieur',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'depressed',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'hurt',
    'nameFr': 'blessé',
    'level': 1,
    'basicEmotion': 'sad',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'disappointed',
    'nameFr': 'déçu',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'hurt',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'embarassed',
    'nameFr': 'embarassé',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'hurt',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'disgusted',
    'nameFr': 'dégoûté',
    'level': 0,
    'basicEmotion': '',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'repelled',
    'nameFr': 'repoussé',
    'level': 1,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'hesitant',
    'nameFr': 'hesitant',
    'level': 2,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': 'repelled',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'horrified',
    'nameFr': 'horrifié',
    'level': 2,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': 'repelled',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'awful',
    'nameFr': 'terrible',
    'level': 1,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'detestable',
    'nameFr': 'détestable',
    'level': 2,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': 'awful',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'nauseated',
    'nameFr': 'nauséeux',
    'level': 2,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': 'awful',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'uncomfortable',
    'nameFr': 'repoussé',
    'level': 1,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'revolted',
    'nameFr': 'revolté',
    'level': 2,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': 'uncomfortable',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'appalled',
    'nameFr': 'atterré',
    'level': 2,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': 'uncomfortable',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'disapproving',
    'nameFr': 'désaprobateur',
    'level': 1,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'condemned',
    'nameFr': 'condamné',
    'level': 2,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': 'disapproving',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'judgmental',
    'nameFr': 'critique',
    'level': 2,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': 'disapproving',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'surprised',
    'nameFr': 'surpris',
    'level': 0,
    'basicEmotion': '',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'excited',
    'nameFr': 'enthousiaste',
    'level': 1,
    'basicEmotion': 'surprised',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'energetic',
    'nameFr': 'énergique',
    'level': 2,
    'basicEmotion': 'surprised',
    'intermediateEmotion': 'excited',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'eager',
    'nameFr': 'désireux',
    'level': 2,
    'basicEmotion': 'surprised',
    'intermediateEmotion': 'excited',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'amazed',
    'nameFr': 'émerveillé',
    'level': 1,
    'basicEmotion': 'surprised',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'awe',
    'nameFr': 'admiratif',
    'level': 2,
    'basicEmotion': 'surprised',
    'intermediateEmotion': 'amazed',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'astonished',
    'nameFr': 'étonné',
    'level': 2,
    'basicEmotion': 'surprised',
    'intermediateEmotion': 'amazed',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'confused',
    'nameFr': 'confus',
    'level': 1,
    'basicEmotion': 'surprised',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'perplexed',
    'nameFr': 'perplexe',
    'level': 2,
    'basicEmotion': 'surprised',
    'intermediateEmotion': 'confused',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'disillusioned',
    'nameFr': 'désillusionné',
    'level': 2,
    'basicEmotion': 'surprised',
    'intermediateEmotion': 'confused',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'startled',
    'nameFr': 'surpris',
    'level': 1,
    'basicEmotion': 'surprised',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'dismayed',
    'nameFr': 'consterné',
    'level': 2,
    'basicEmotion': 'surprised',
    'intermediateEmotion': 'startled',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'shocked',
    'nameFr': 'choqué',
    'level': 2,
    'basicEmotion': 'surprised',
    'intermediateEmotion': 'startled',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'bad',
    'nameFr': 'mal',
    'level': 0,
    'basicEmotion': '',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'tired',
    'nameFr': 'fatigué',
    'level': 1,
    'basicEmotion': 'bad',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'sleepy',
    'nameFr': 'somnolent',
    'level': 2,
    'basicEmotion': 'bad',
    'intermediateEmotion': 'tired',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'unfocused',
    'nameFr': 'déconcentré',
    'level': 2,
    'basicEmotion': 'bad',
    'intermediateEmotion': 'tired',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'stressed',
    'nameFr': 'stressé',
    'level': 1,
    'basicEmotion': 'bad',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'out of control',
    'nameFr': 'hors de contrôle',
    'level': 2,
    'basicEmotion': 'bad',
    'intermediateEmotion': 'stressed',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'overwhelmed',
    'nameFr': 'débordé',
    'level': 2,
    'basicEmotion': 'bad',
    'intermediateEmotion': 'stressed',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'busy',
    'nameFr': 'occupé',
    'level': 1,
    'basicEmotion': 'bad',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'rushed',
    'nameFr': 'précipité',
    'level': 2,
    'basicEmotion': 'bad',
    'intermediateEmotion': 'busy',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'pressured',
    'nameFr': 'sous pression',
    'level': 2,
    'basicEmotion': 'bad',
    'intermediateEmotion': 'busy',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'bored',
    'nameFr': 'ennuyé',
    'level': 1,
    'basicEmotion': 'bad',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'apathetic',
    'nameFr': 'apathique',
    'level': 2,
    'basicEmotion': 'bad',
    'intermediateEmotion': 'bored',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'indifferent',
    'nameFr': 'indifférent',
    'level': 2,
    'basicEmotion': 'bad',
    'intermediateEmotion': 'bored',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'fearful',
    'nameFr': 'craintif',
    'level': 0,
    'basicEmotion': '',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'scared',
    'nameFr': 'effrayé',
    'level': 1,
    'basicEmotion': 'fearful',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'helpless',
    'nameFr': 'sans défense',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'scared',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'frightened',
    'nameFr': 'terrifié',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'scared',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'anxious',
    'nameFr': 'anxieux',
    'level': 1,
    'basicEmotion': 'fearful',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'overwhelmed',
    'nameFr': 'submergé',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'anxious',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'worried',
    'nameFr': 'inquiet',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'anxious',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'insecure',
    'nameFr': 'incertain',
    'level': 1,
    'basicEmotion': 'fearful',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'inadequate',
    'nameFr': 'inadapté',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'insecure',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'inferior',
    'nameFr': 'inférieur',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'insecure',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'weak',
    'nameFr': 'faible',
    'level': 1,
    'basicEmotion': 'fearful',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'worthless',
    'nameFr': 'inutile',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'weak',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'insignificant',
    'nameFr': 'insignifiant',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'weak',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'rejected',
    'nameFr': 'rejeté',
    'level': 1,
    'basicEmotion': 'fearful',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'excluded',
    'nameFr': 'exclus',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'rejected',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'persecuted',
    'nameFr': 'persécuté',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'rejected',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'threatened',
    'nameFr': 'menacé',
    'level': 1,
    'basicEmotion': 'fearful',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'nervous',
    'nameFr': 'nerveux',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'threatened',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'exposed',
    'nameFr': 'exposé',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'threatened',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'angry',
    'nameFr': 'en colère',
    'level': 0,
    'basicEmotion': '',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'let down',
    'nameFr': 'déçu',
    'level': 1,
    'basicEmotion': 'angry',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'betrayed',
    'nameFr': 'trahi',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'let down',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'resentful',
    'nameFr': 'rancunier',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'let down',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'humilated',
    'nameFr': 'humilié',
    'level': 1,
    'basicEmotion': 'angry',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'disrespected',
    'nameFr': 'non respecté',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'humilated',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'ridiculed',
    'nameFr': 'ridiculisé',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'humilated',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'bitter',
    'nameFr': 'amer',
    'level': 1,
    'basicEmotion': 'angry',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'indignant',
    'nameFr': 'indigné',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'bitter',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'violated',
    'nameFr': 'violé',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'bitter',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'mad',
    'nameFr': 'fou',
    'level': 1,
    'basicEmotion': 'angry',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'furious',
    'nameFr': 'furieux',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'mad',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'jealous',
    'nameFr': 'jaloux',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'mad',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'aggressive',
    'nameFr': 'aggressif',
    'level': 1,
    'basicEmotion': 'angry',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'provoked',
    'nameFr': 'provoqué',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'aggressive',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'hostile',
    'nameFr': 'hostile',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'aggressive',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'frustrated',
    'nameFr': 'frustré',
    'level': 1,
    'basicEmotion': 'angry',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'infuriated',
    'nameFr': 'excédé',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'frustrated',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'annoyed',
    'nameFr': 'agacé',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'frustrated',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'distant',
    'nameFr': 'distant',
    'level': 1,
    'basicEmotion': 'angry',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'withdrawn',
    'nameFr': 'retiré',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'distant',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'numb',
    'nameFr': 'engourdi',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'distant',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'critical',
    'nameFr': 'critique',
    'level': 1,
    'basicEmotion': 'angry',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'sceptical',
    'nameFr': 'sceptique',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'critical',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'dismissive',
    'nameFr': 'dédaigneux',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'critical',
    'lastUse': lastUse,
    'selectedCount': 0
  },
];
