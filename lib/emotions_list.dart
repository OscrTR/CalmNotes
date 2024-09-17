final lastUse = DateTime.now().toUtc().millisecondsSinceEpoch;

List<Map<String, dynamic>> emotions = [
  {
    'nameEn': 'happy',
    'nameFr': 'heureux·se',
    'level': 0,
    'basicEmotion': '',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'playful',
    'nameFr': 'enjoué·e',
    'level': 1,
    'basicEmotion': 'happy',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'aroused',
    'nameFr': 'excité·e',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'playful',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'cheeky',
    'nameFr': 'effronté·e',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'playful',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'content',
    'nameFr': 'satisfait·e',
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
    'nameFr': 'joyeux·se',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'content',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'interested',
    'nameFr': 'intéressé·e',
    'level': 1,
    'basicEmotion': 'happy',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'curious',
    'nameFr': 'curieux·se',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'interested',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'inquisitive',
    'nameFr': 'inquisiteur·rice',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'interested',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'proud',
    'nameFr': 'fier·e',
    'level': 1,
    'basicEmotion': 'happy',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'successful',
    'nameFr': 'performant·e',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'proud',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'confident',
    'nameFr': 'confiant·e',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'proud',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'accepted',
    'nameFr': 'accepté·e',
    'level': 1,
    'basicEmotion': 'happy',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'respected',
    'nameFr': 'respecté·e',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'accepted',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'valued',
    'nameFr': 'valorisé·e',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'accepted',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'powerful',
    'nameFr': 'puissant·e',
    'level': 1,
    'basicEmotion': 'happy',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'courageous',
    'nameFr': 'courageux·se',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'powerful',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'creative',
    'nameFr': 'creatif·ve',
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
    'nameFr': 'aimant·e',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'peaceful',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'thankful',
    'nameFr': 'reconaissant·e',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'peaceful',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'trusting',
    'nameFr': 'confiant·e',
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
    'nameFr': "plein·e d/'espoir",
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'optimistic',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'inspired',
    'nameFr': 'inspiré·e',
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
    'nameFr': 'seul·e',
    'level': 1,
    'basicEmotion': 'sad',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'abandoned',
    'nameFr': 'abandonné·e',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'lonely',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'isolated',
    'nameFr': 'isolé·e',
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
    'nameFr': 'victimisé·e',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'vulnerable',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'despair',
    'nameFr': 'désespéré·e',
    'level': 1,
    'basicEmotion': 'sad',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'powerless',
    'nameFr': 'impuissant·e',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'despair',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'grief',
    'nameFr': 'chagriné·e',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'despair',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'guilty',
    'nameFr': 'coupable',
    'level': 1,
    'basicEmotion': 'sad',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'ashamed',
    'nameFr': 'honteux·se',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'guilty',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'remorseful',
    'nameFr': 'plein·e de remords',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'guilty',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'depressed',
    'nameFr': 'deprimé·e',
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
    'nameFr': 'inférieur·e',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'depressed',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'hurt',
    'nameFr': 'blessé·e',
    'level': 1,
    'basicEmotion': 'sad',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'disappointed',
    'nameFr': 'déçu·e',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'hurt',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'embarassed',
    'nameFr': 'embarassé·e',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'hurt',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'disgusted',
    'nameFr': 'dégoûté·e',
    'level': 0,
    'basicEmotion': '',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'repelled',
    'nameFr': 'repoussé·e',
    'level': 1,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'hesitant',
    'nameFr': 'hesitant·e',
    'level': 2,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': 'repelled',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'horrified',
    'nameFr': 'horrifié·e',
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
    'nameFr': 'nauséeux·se',
    'level': 2,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': 'awful',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'uncomfortable',
    'nameFr': 'repoussé·e',
    'level': 1,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'revolted',
    'nameFr': 'revolté·e',
    'level': 2,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': 'uncomfortable',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'appalled',
    'nameFr': 'atterré·e',
    'level': 2,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': 'uncomfortable',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'disapproving',
    'nameFr': 'désaprobateur·rice',
    'level': 1,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'condemned',
    'nameFr': 'condamné·e',
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
    'nameFr': 'surpris·e',
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
    'nameFr': 'désireux·se',
    'level': 2,
    'basicEmotion': 'surprised',
    'intermediateEmotion': 'excited',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'amazed',
    'nameFr': 'émerveillé·e',
    'level': 1,
    'basicEmotion': 'surprised',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'awe',
    'nameFr': 'admiratif·ve',
    'level': 2,
    'basicEmotion': 'surprised',
    'intermediateEmotion': 'amazed',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'astonished',
    'nameFr': 'étonné·e',
    'level': 2,
    'basicEmotion': 'surprised',
    'intermediateEmotion': 'amazed',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'confused',
    'nameFr': 'confus·e',
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
    'nameFr': 'désillusionné·e',
    'level': 2,
    'basicEmotion': 'surprised',
    'intermediateEmotion': 'confused',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'startled',
    'nameFr': 'surpris·e',
    'level': 1,
    'basicEmotion': 'surprised',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'dismayed',
    'nameFr': 'consterné·e',
    'level': 2,
    'basicEmotion': 'surprised',
    'intermediateEmotion': 'startled',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'shocked',
    'nameFr': 'choqué·e',
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
    'nameFr': 'fatigué·e',
    'level': 1,
    'basicEmotion': 'bad',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'sleepy',
    'nameFr': 'somnolent·e',
    'level': 2,
    'basicEmotion': 'bad',
    'intermediateEmotion': 'tired',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'unfocused',
    'nameFr': 'déconcentré·e',
    'level': 2,
    'basicEmotion': 'bad',
    'intermediateEmotion': 'tired',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'stressed',
    'nameFr': 'stressé·e',
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
    'nameFr': 'débordé·e',
    'level': 2,
    'basicEmotion': 'bad',
    'intermediateEmotion': 'stressed',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'busy',
    'nameFr': 'occupé·e',
    'level': 1,
    'basicEmotion': 'bad',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'rushed',
    'nameFr': 'précipité·e',
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
    'nameFr': 'ennuyé·e',
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
    'nameFr': 'indifférent·e',
    'level': 2,
    'basicEmotion': 'bad',
    'intermediateEmotion': 'bored',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'fearful',
    'nameFr': 'craintif·ve',
    'level': 0,
    'basicEmotion': '',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'scared',
    'nameFr': 'effrayé·e',
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
    'nameFr': 'terrifié·e',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'scared',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'anxious',
    'nameFr': 'anxieux·se',
    'level': 1,
    'basicEmotion': 'fearful',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'overwhelmed',
    'nameFr': 'submergé·e',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'anxious',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'worried',
    'nameFr': 'inquiet·e',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'anxious',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'insecure',
    'nameFr': 'incertain·e',
    'level': 1,
    'basicEmotion': 'fearful',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'inadequate',
    'nameFr': 'inadapté·e',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'insecure',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'inferior',
    'nameFr': 'inférieur·e',
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
    'nameFr': 'insignifiant·e',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'weak',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'rejected',
    'nameFr': 'rejeté·e',
    'level': 1,
    'basicEmotion': 'fearful',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'excluded',
    'nameFr': 'exclu·e',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'rejected',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'persecuted',
    'nameFr': 'persécuté·e',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'rejected',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'threatened',
    'nameFr': 'menacé·e',
    'level': 1,
    'basicEmotion': 'fearful',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'nervous',
    'nameFr': 'nerveux·se',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'threatened',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'exposed',
    'nameFr': 'exposé·e',
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
    'nameFr': 'déçu·e',
    'level': 1,
    'basicEmotion': 'angry',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'betrayed',
    'nameFr': 'trahi·e',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'let down',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'resentful',
    'nameFr': 'rancunier·e',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'let down',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'humilated',
    'nameFr': 'humilié·e',
    'level': 1,
    'basicEmotion': 'angry',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'disrespected',
    'nameFr': 'non respecté·e',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'humilated',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'ridiculed',
    'nameFr': 'ridiculisé·e',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'humilated',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'bitter',
    'nameFr': 'amer·e',
    'level': 1,
    'basicEmotion': 'angry',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'indignant',
    'nameFr': 'indigné·e',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'bitter',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'violated',
    'nameFr': 'violé·e',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'bitter',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'mad',
    'nameFr': 'fou·lle',
    'level': 1,
    'basicEmotion': 'angry',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'furious',
    'nameFr': 'furieux·se',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'mad',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'jealous',
    'nameFr': 'jaloux·se',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'mad',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'aggressive',
    'nameFr': 'aggressif·ve',
    'level': 1,
    'basicEmotion': 'angry',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'provoked',
    'nameFr': 'provoqué·e',
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
    'nameFr': 'frustré·e',
    'level': 1,
    'basicEmotion': 'angry',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'infuriated',
    'nameFr': 'excédé·e',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'frustrated',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'annoyed',
    'nameFr': 'agacé·e',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'frustrated',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'distant',
    'nameFr': 'distant·e',
    'level': 1,
    'basicEmotion': 'angry',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'withdrawn',
    'nameFr': 'retiré·e',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'distant',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'numb',
    'nameFr': 'engourdi·e',
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
    'nameFr': 'dédaigneux·se',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'critical',
    'lastUse': lastUse,
    'selectedCount': 0
  },
];
