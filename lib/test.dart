/*
fetchEvents() async {
  try {
    String userId = AuthenticationService().getCurrentUserId();

    final QuerySnapshot eventSnapshot = await FirebaseFirestore.instance
        .collection('User')
        .doc(userId)
        .collection('Evenement_cree')
        .get();

    setState(() {
      events = eventSnapshot.docs.map((doc) =>
          Event.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    });
  } catch (e) {
    print("Erreur lors de la récupération des événements : $e");
  }
}

 */