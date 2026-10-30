import 'dart:async';

abstract class Kendaraan {
  final String plat;
  Kendaraan(this.plat);

  String get jenis;
  int get tarifPerJam;

  int biaya(int jam) => tarifPerJam * jam;
}

class Motor extends Kendaraan {
  Motor(super.plat);
  @override
  String get jenis => 'Motor';
  @override
  int get tarifPerJam => 2000;
}

class Mobil extends Kendaraan {
  Mobil(super.plat);
  @override
  String get jenis => 'Mobil';
  @override
  int get tarifPerJam => 5000;
}

class Truk extends Kendaraan {
  Truk(super.plat);
  @override
  String get jenis => 'Truk';
  @override
  int get tarifPerJam => 10000;
}

mixin DiskonMember on Kendaraan {
  @override
  int biaya(int jam) => super.biaya(jam)  ~/ 2;
}

class MobilMember extends Mobil with DiskonMember {
  MobilMember(super.plat);
  @override
  String get jenis => 'Mobil (member)';
}

class ParkirPenuh implements Exception {
  final String pesan;
  ParkirPenuh([this.pesan = 'Parkiran penuh']);
}

class Parkiran {
  final int _kapasitas;
  final List<Kendaraan> _terparkir = [];
  int _pendapatan = 0;
  final StreamController<String> _pos = StreamController<String>.broadcast();

  Parkiran(this._kapasitas);

  int get sisa => _kapasitas - _terparkir.length;
  int get pendapatan => _pendapatan;
  Stream<String> get layarPos => _pos.stream;

  Future<void> masuk(Kendaraan k) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (sisa <= 0) throw ParkirPenuh();
    _terparkir.add(k);
    _pos.add('MASUK  ${k.jenis} ${k.plat} (sisa $sisa)');
  }

  Future<void> keluar(Kendaraan k, int jam) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!_terparkir.remove(k)) {
      throw StateError('${k.plat} tidak ada di parkiran');
    }
    final bayar = k.biaya(jam);
    _pendapatan += bayar;
    _pos.add('KELUAR ${k.jenis} ... bayar Rp$bayar');
  }

  Future<void> tutup() => _pos.close();
}

Future<void> cobaMasuk(Parkiran p, Kendaraan k) async {
  try {
    await p.masuk(k);
  } on ParkirPenuh catch (e) {
    print('Ditolak: ${e.pesan}');
  }
}

Future<void> main() async {
  final parkiran = Parkiran(3);

  final langganan = parkiran.layarPos.listen(print);

  final motor = Motor('BK 1923 WO');
  final mobil = Mobil('BK 22 AP');
  final member = MobilMember('BK 1 RI');
  final truk = Truk('BK 9 XYZ');

  await cobaMasuk(parkiran, motor);
  await cobaMasuk(parkiran, mobil);
  await cobaMasuk(parkiran, member);
  await cobaMasuk(parkiran, truk); 

  await parkiran.keluar(motor, 3);
  await parkiran.keluar(mobil, 3);
  await parkiran.keluar(member, 3);

  print('Pendapatan: Rp${parkiran.pendapatan}');

  await parkiran.tutup();
  await langganan.cancel();
}