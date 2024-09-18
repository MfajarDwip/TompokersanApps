import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_kepuharjo_new/Model/Pengajuan.dart';
import 'package:mobile_kepuharjo_new/Resource/Mycolor.dart';
import 'package:mobile_kepuharjo_new/Resource/Myfont.dart';
import 'package:mobile_kepuharjo_new/Services/api_services.dart';

class SuratDitolak extends StatefulWidget {
  const SuratDitolak({super.key});

  @override
  State<SuratDitolak> createState() => _SuratDitolakState();
}

class _SuratDitolakState extends State<SuratDitolak> {
  List<Pengajuan> pengajuan = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSuratDitolak();
  }

  Future<void> getSuratDitolak() async {
    final api = ApiServices();
    final surat = await api.getPengajuanRt("Ditolak RT");
    setState(() {
      pengajuan = surat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(10),
            child: Card(
              elevation: 3, // tinggi bayangan
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Surat Ditolak",
                            style: MyFont.poppins(
                                fontSize: 14,
                                color: black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Menampilkan data surat yang telah ditolak oleh pihak RT",
                            style: MyFont.poppins(
                                fontSize: 12,
                                color: softgrey,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                          columns: [
                            DataColumn(
                              label: Text(
                                "No.",
                                style: MyFont.poppins(
                                    fontSize: 12, color: black),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Nama",
                                style: MyFont.poppins(
                                    fontSize: 12, color: black),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Jenis",
                                style: MyFont.poppins(
                                    fontSize: 12, color: black),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Status",
                                style: MyFont.poppins(
                                    fontSize: 12, color: black),
                              ),
                            ),
                          ],
                          rows: pengajuan.map((e) {
                            return DataRow(cells: [
                              DataCell(Text(
                                ('${pengajuan.indexOf(e) + 1}').toString(),
                                style: MyFont.poppins(
                                    fontSize: 11, color: black),
                              )),
                              DataCell(Text(
                                e.masyarakat!.namaLengkap.toString(),
                                style: MyFont.poppins(
                                    fontSize: 11, color: black),
                              )),
                              DataCell(Text(
                                e.surat!.namaSurat.toString(),
                                style: MyFont.poppins(
                                    fontSize: 11, color: black),
                              )),
                              DataCell(Container(
                                height: 20,
                                width: 80,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.red),
                                child: Center(
                                  child: Text(
                                    e.status.toString(),
                                    textAlign: TextAlign.center,
                                    style: MyFont.poppins(
                                        fontSize: 11, color: white),
                                  ),
                                ),
                              )),
                            ]);
                          }).toList()),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
