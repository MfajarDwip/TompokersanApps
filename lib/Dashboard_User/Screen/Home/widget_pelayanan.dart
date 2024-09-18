import 'package:flutter/material.dart';
import 'package:mobile_kepuharjo_new/Dashboard_User/Screen/Pengajuan/daftar_keluarga.dart';
import 'package:mobile_kepuharjo_new/Model/Surat.dart';
import 'package:mobile_kepuharjo_new/Resource/Mycolor.dart';
import 'package:mobile_kepuharjo_new/Resource/Myfont.dart';
import 'package:mobile_kepuharjo_new/Services/api_connect.dart';
import 'package:mobile_kepuharjo_new/Services/api_services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WidgetPelayanan extends StatefulWidget {
  const WidgetPelayanan({Key? key}) : super(key: key);

  @override
  State<WidgetPelayanan> createState() => _WidgetPelayananState();
}

class _WidgetPelayananState extends State<WidgetPelayanan> {
  ApiServices apiServices = ApiServices();
  late Future<List<Surat>> listdata;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    listdata = apiServices.getSurat();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 25, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Layanan Pengajuan Surat Keterangan",
                  style: MyFont.poppins(
                    fontSize: 16, // Ukuran teks lebih besar
                    color: black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Berbagai layanan pengajuan surat keterangan",
                  style: MyFont.poppins(
                    fontSize: 14, // Ukuran teks lebih besar
                    color: softgrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          SizedBox(
            height:
                350, // Tinggi container diperbesar untuk mengakomodasi konten
            child: FutureBuilder<List<Surat>>(
              future: listdata,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Surat>? isiData = snapshot.data;
                  int totalPages = (isiData!.length / 8).ceil();

                  return Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (page) {
                            setState(() {
                              _currentPage = page;
                            });
                          },
                          itemCount: totalPages,
                          itemBuilder: (context, pageIndex) {
                            int startIndex = pageIndex * 8;
                            int endIndex = startIndex + 8;
                            endIndex = endIndex > isiData.length
                                ? isiData.length
                                : endIndex;

                            return GridView.builder(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 15,
                                mainAxisExtent: 160, // Tinggi item lebih besar
                              ),
                              itemCount: endIndex - startIndex,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DaftarKeluarga(
                                          selectedSurat:
                                              isiData[startIndex + index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 75,
                                        child: Image.network(
                                          Api.connectimage +
                                              isiData[startIndex + index]
                                                  .image
                                                  .toString(),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        isiData[startIndex + index]
                                            .namaSurat
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize:
                                              12, // Ukuran teks lebih besar
                                          color: black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: totalPages,
                        effect: WormEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          activeDotColor: Colors.blue,
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error loading data"));
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
