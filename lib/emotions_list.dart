final lastUse = DateTime.now().toUtc().millisecondsSinceEpoch;

List<Map<String, dynamic>> emotions = [
  {
    'nameEn': 'happy',
    'nameFr': 'bonheur',
    'level': 0,
    'basicEmotion': '',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'playful',
    'nameFr': 'ludisme',
    'level': 1,
    'basicEmotion': 'happy',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'aroused',
    'nameFr': 'désir',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'playful',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'cheeky',
    'nameFr': 'malice',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'playful',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'content',
    'nameFr': 'satisfaction',
    'level': 1,
    'basicEmotion': 'happy',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'free',
    'nameFr': 'liberté',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'content',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'joyful',
    'nameFr': 'joie',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'content',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'interested',
    'nameFr': 'intérêt',
    'level': 1,
    'basicEmotion': 'happy',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'curious',
    'nameFr': 'curiosité',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'interested',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'inquisitive',
    'nameFr': 'indiscret',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'interested',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'proud',
    'nameFr': 'fierté',
    'level': 1,
    'basicEmotion': 'happy',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'successful',
    'nameFr': 'réalisation',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'proud',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'confident',
    'nameFr': 'confiance',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'proud',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'accepted',
    'nameFr': 'acceptation',
    'level': 1,
    'basicEmotion': 'happy',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'respected',
    'nameFr': 'respect',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'accepted',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'valued',
    'nameFr': 'valorisation',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'accepted',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'powerful',
    'nameFr': 'puissance',
    'level': 1,
    'basicEmotion': 'happy',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'courageous',
    'nameFr': 'courage',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'powerful',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'creative',
    'nameFr': 'creativité',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'powerful',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'peaceful',
    'nameFr': 'paix',
    'level': 1,
    'basicEmotion': 'happy',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'loving',
    'nameFr': 'affection',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'peaceful',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'thankful',
    'nameFr': 'reconaissance',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'peaceful',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'trusting',
    'nameFr': 'confiance',
    'level': 1,
    'basicEmotion': 'happy',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'sensitive',
    'nameFr': 'sensibilité',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'trusting',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'intimate',
    'nameFr': 'intimité',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'trusting',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'optimistic',
    'nameFr': 'optimisme',
    'level': 1,
    'basicEmotion': 'happy',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'hopeful',
    'nameFr': 'espoir',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'optimistic',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'inspired',
    'nameFr': 'inspiration',
    'level': 2,
    'basicEmotion': 'happy',
    'intermediateEmotion': 'optimistic',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'sad',
    'nameFr': 'tristesse',
    'level': 0,
    'basicEmotion': '',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'lonely',
    'nameFr': 'solitude',
    'level': 1,
    'basicEmotion': 'sad',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'abandoned',
    'nameFr': 'abandon',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'lonely',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'isolated',
    'nameFr': 'isolation',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'lonely',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'vulnerable',
    'nameFr': 'vulnerabilité',
    'level': 1,
    'basicEmotion': 'sad',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'fragile',
    'nameFr': 'fragilité',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'vulnerable',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'victimised',
    'nameFr': 'victimisation',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'vulnerable',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'despair',
    'nameFr': 'désespoir',
    'level': 1,
    'basicEmotion': 'sad',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'powerless',
    'nameFr': 'impuissance',
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
    'nameFr': 'culpabilité',
    'level': 1,
    'basicEmotion': 'sad',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'ashamed',
    'nameFr': 'honte',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'guilty',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'remorseful',
    'nameFr': 'remord',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'guilty',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'depressed',
    'nameFr': 'depression',
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
    'nameFr': 'infériorité',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'depressed',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'hurt',
    'nameFr': 'peine',
    'level': 1,
    'basicEmotion': 'sad',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'disappointed',
    'nameFr': 'déception',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'hurt',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'embarassed',
    'nameFr': 'embaras',
    'level': 2,
    'basicEmotion': 'sad',
    'intermediateEmotion': 'hurt',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'disgusted',
    'nameFr': 'dégoût',
    'level': 0,
    'basicEmotion': '',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'repelled',
    'nameFr': 'repulsion',
    'level': 1,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'hesitant',
    'nameFr': 'hesitation',
    'level': 2,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': 'repelled',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'horrified',
    'nameFr': 'horreur',
    'level': 2,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': 'repelled',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'awful',
    'nameFr': 'détresse',
    'level': 1,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'detestable',
    'nameFr': 'haine',
    'level': 2,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': 'awful',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'nauseated',
    'nameFr': 'malaise',
    'level': 2,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': 'awful',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'uncomfortable',
    'nameFr': 'gêne',
    'level': 1,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'revolted',
    'nameFr': 'revolte',
    'level': 2,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': 'uncomfortable',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'appalled',
    'nameFr': 'consternation',
    'level': 2,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': 'uncomfortable',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'disapproving',
    'nameFr': 'désaprobation',
    'level': 1,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'condemned',
    'nameFr': 'blâme',
    'level': 2,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': 'disapproving',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'judgmental',
    'nameFr': 'jugement',
    'level': 2,
    'basicEmotion': 'disgusted',
    'intermediateEmotion': 'disapproving',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'surprised',
    'nameFr': 'surprise',
    'level': 0,
    'basicEmotion': '',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'excited',
    'nameFr': 'enthousiasme',
    'level': 1,
    'basicEmotion': 'surprised',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'energetic',
    'nameFr': 'dynamisme',
    'level': 2,
    'basicEmotion': 'surprised',
    'intermediateEmotion': 'excited',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'eager',
    'nameFr': 'désir',
    'level': 2,
    'basicEmotion': 'surprised',
    'intermediateEmotion': 'excited',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'amazed',
    'nameFr': 'émerveillement',
    'level': 1,
    'basicEmotion': 'surprised',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'awe',
    'nameFr': 'admiration',
    'level': 2,
    'basicEmotion': 'surprised',
    'intermediateEmotion': 'amazed',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'astonished',
    'nameFr': 'étonnement',
    'level': 2,
    'basicEmotion': 'surprised',
    'intermediateEmotion': 'amazed',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'confused',
    'nameFr': 'confusion',
    'level': 1,
    'basicEmotion': 'surprised',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'perplexed',
    'nameFr': 'perplexité',
    'level': 2,
    'basicEmotion': 'surprised',
    'intermediateEmotion': 'confused',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'disillusioned',
    'nameFr': 'désillusion',
    'level': 2,
    'basicEmotion': 'surprised',
    'intermediateEmotion': 'confused',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'startled',
    'nameFr': 'surprise',
    'level': 1,
    'basicEmotion': 'surprised',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'dismayed',
    'nameFr': 'consternation',
    'level': 2,
    'basicEmotion': 'surprised',
    'intermediateEmotion': 'startled',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'shocked',
    'nameFr': 'choc',
    'level': 2,
    'basicEmotion': 'surprised',
    'intermediateEmotion': 'startled',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'bad',
    'nameFr': 'mal-être',
    'level': 0,
    'basicEmotion': '',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'tired',
    'nameFr': 'fatigue',
    'level': 1,
    'basicEmotion': 'bad',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'sleepy',
    'nameFr': 'somnolence',
    'level': 2,
    'basicEmotion': 'bad',
    'intermediateEmotion': 'tired',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'unfocused',
    'nameFr': 'distraction',
    'level': 2,
    'basicEmotion': 'bad',
    'intermediateEmotion': 'tired',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'stressed',
    'nameFr': 'stress',
    'level': 1,
    'basicEmotion': 'bad',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'out of control',
    'nameFr': 'panique',
    'level': 2,
    'basicEmotion': 'bad',
    'intermediateEmotion': 'stressed',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'overwhelmed',
    'nameFr': 'submersion',
    'level': 2,
    'basicEmotion': 'bad',
    'intermediateEmotion': 'stressed',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'busy',
    'nameFr': 'préoccupation',
    'level': 1,
    'basicEmotion': 'bad',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'rushed',
    'nameFr': 'précipitation',
    'level': 2,
    'basicEmotion': 'bad',
    'intermediateEmotion': 'busy',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'pressured',
    'nameFr': 'tension',
    'level': 2,
    'basicEmotion': 'bad',
    'intermediateEmotion': 'busy',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'bored',
    'nameFr': 'ennui',
    'level': 1,
    'basicEmotion': 'bad',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'apathetic',
    'nameFr': 'apathie',
    'level': 2,
    'basicEmotion': 'bad',
    'intermediateEmotion': 'bored',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'indifferent',
    'nameFr': 'indifférence',
    'level': 2,
    'basicEmotion': 'bad',
    'intermediateEmotion': 'bored',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'fearful',
    'nameFr': 'crainte',
    'level': 0,
    'basicEmotion': '',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'scared',
    'nameFr': 'effroi',
    'level': 1,
    'basicEmotion': 'fearful',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'helpless',
    'nameFr': 'impuissance',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'scared',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'frightened',
    'nameFr': 'détresse',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'scared',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'anxious',
    'nameFr': 'anxiété',
    'level': 1,
    'basicEmotion': 'fearful',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'overwhelmed',
    'nameFr': 'submersion',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'anxious',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'worried',
    'nameFr': 'inquiétude',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'anxious',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'insecure',
    'nameFr': 'doute',
    'level': 1,
    'basicEmotion': 'fearful',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'inadequate',
    'nameFr': 'inadéquation',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'insecure',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'inferior',
    'nameFr': 'infériorité',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'insecure',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'weak',
    'nameFr': 'faiblesse',
    'level': 1,
    'basicEmotion': 'fearful',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'worthless',
    'nameFr': 'inutilité',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'weak',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'insignificant',
    'nameFr': 'insignifiance',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'weak',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'rejected',
    'nameFr': 'rejet',
    'level': 1,
    'basicEmotion': 'fearful',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'excluded',
    'nameFr': 'exclusion',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'rejected',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'persecuted',
    'nameFr': 'persécution',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'rejected',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'threatened',
    'nameFr': 'menace',
    'level': 1,
    'basicEmotion': 'fearful',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'nervous',
    'nameFr': 'nervosité',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'threatened',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'exposed',
    'nameFr': 'vulnérabilité',
    'level': 2,
    'basicEmotion': 'fearful',
    'intermediateEmotion': 'threatened',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'angry',
    'nameFr': 'colère',
    'level': 0,
    'basicEmotion': '',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'let down',
    'nameFr': 'déception',
    'level': 1,
    'basicEmotion': 'angry',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'betrayed',
    'nameFr': 'trahison',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'let down',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'resentful',
    'nameFr': 'rancune',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'let down',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'humilated',
    'nameFr': 'humiliation',
    'level': 1,
    'basicEmotion': 'angry',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'disrespected',
    'nameFr': 'frustration',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'humilated',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'ridiculed',
    'nameFr': 'ridicule',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'humilated',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'bitter',
    'nameFr': 'amertume',
    'level': 1,
    'basicEmotion': 'angry',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'indignant',
    'nameFr': 'indignation',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'bitter',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'violated',
    'nameFr': 'trahison',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'bitter',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'mad',
    'nameFr': 'folie',
    'level': 1,
    'basicEmotion': 'angry',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'furious',
    'nameFr': 'fureur',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'mad',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'jealous',
    'nameFr': 'jalousie',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'mad',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'aggressive',
    'nameFr': 'aggressivité',
    'level': 1,
    'basicEmotion': 'angry',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'provoked',
    'nameFr': 'irritation',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'aggressive',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'hostile',
    'nameFr': 'hostilité',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'aggressive',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'frustrated',
    'nameFr': 'frustration',
    'level': 1,
    'basicEmotion': 'angry',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'infuriated',
    'nameFr': 'rage',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'frustrated',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'annoyed',
    'nameFr': 'agacement',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'frustrated',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'distant',
    'nameFr': 'froideur',
    'level': 1,
    'basicEmotion': 'angry',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'withdrawn',
    'nameFr': 'repli sur soi',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'distant',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'numb',
    'nameFr': 'insensibilité',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'distant',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'critical',
    'nameFr': 'sévérité',
    'level': 1,
    'basicEmotion': 'angry',
    'intermediateEmotion': '',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'sceptical',
    'nameFr': 'scepticité',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'critical',
    'lastUse': lastUse,
    'selectedCount': 0
  },
  {
    'nameEn': 'dismissive',
    'nameFr': 'dédain',
    'level': 2,
    'basicEmotion': 'angry',
    'intermediateEmotion': 'critical',
    'lastUse': lastUse,
    'selectedCount': 0
  },
];
