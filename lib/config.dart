import 'dart:io';

//Directory retail = Directory("C:\Program Files (x86)\World of Warcraft\_retail_");

main() {
  void listFiles(Directory retail) async {
    print(await retail.list().toList());
  }

  Directory retail = Directory(r"C:\Program Files (x86)\World of Warcraft\_retail_\");
  listFiles(retail);
}

// Search for addon
// https://addons-ecs.forgesvc.net/api/v2/addon/search?categoryId=0&gameId=1&gameVersion=8.3.0&index=0&pageSize=1&searchFilter=BigWigs%20Azeroth&sort=0
