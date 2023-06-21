class Wallet {
  int id;
  String password;
  String passphrase;
  String hex;
  String seed;

  Wallet({
    this.id,
    this.password,
    this.passphrase,
    this.hex,
    this.seed
  });

  factory Wallet.fromMap(Map<dynamic, dynamic> map) {
    return Wallet(
      id: map['id'] ?? '',
      password: map['password'] ?? '',
      hex: map['hex'] ?? '',
      seed: map['seed'] ?? '',
      passphrase: map['passphrase'] ?? '',
    );
  }

  @override
  int compareTo(other) {
    var a = id;
    var b = other.id;

    if(b > a){
      return 1;
    }
    else if(a == b){
      return 0;
    }
    else{
      return -1;
    }
  }

}