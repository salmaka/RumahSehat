package apap.tugas.akhir.rumahsehat.controller.web;

import java.security.Principal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import apap.tugas.akhir.rumahsehat.model.ObatModel;
import apap.tugas.akhir.rumahsehat.model.DTO.BarChartDTO;
import apap.tugas.akhir.rumahsehat.model.DTO.LineChartDTO;
import apap.tugas.akhir.rumahsehat.service.ObatService;
import apap.tugas.akhir.rumahsehat.service.TagihanService;
import apap.tugas.akhir.rumahsehat.service.UserService;

@Controller
public class ChartController {
    @Autowired
    TagihanService tagihanService;

    @Autowired
    UserService userService;

    @Autowired
    ObatService obatService;

    String notFoundError = "error/404";

    @GetMapping("/chart")
    public String defaultLineChart(Model model, Principal principal) {
        if (userService.isAdmin(principal)) {
            Map<String, Long> data = new LinkedHashMap<>();
            List<String> months = new ArrayList<>(Arrays.asList("JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY",
                    "JUNE", "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"));

            for (String month : months) {
                Long pendapatan = tagihanService.getTotalPendapatan(month);
                data.put(month, pendapatan);
            }
            model.addAttribute("data", data);
            return "dashboard/chart/linechart-default";
        } else {
            return notFoundError;
        }

    }

    @GetMapping("/chart/line-obat")
    public String obatChartForm(Model model, Principal principal) {
        if (userService.isAdmin(principal)) {
            var lineChartDTO = new LineChartDTO();
            List<ObatModel> obatList = obatService.getListObat();
            model.addAttribute("lineChartDTO", lineChartDTO);
            model.addAttribute("obatList", obatList);
            return "dashboard/chart/form-line-chart";
        } else {
            return notFoundError;
        }
    }

    @PostMapping("/chart/line-obat")
    public String obatChartView(@ModelAttribute LineChartDTO lineChartDTO, Model model, Principal principal) {
        if (userService.isAdmin(principal)) {
            Map<String, ArrayList<Integer>> data = new LinkedHashMap<>();
            ArrayList<Integer> arr = new ArrayList<>();

            if (lineChartDTO.getObat1() != null)
                data.put(lineChartDTO.getObat1().getNamaObat(), arr);

            if (lineChartDTO.getObat2() != null)
                data.put(lineChartDTO.getObat2().getNamaObat(), arr);

            if (lineChartDTO.getObat3() != null)
                data.put(lineChartDTO.getObat3().getNamaObat(), arr);

            if (lineChartDTO.getObat4() != null)
                data.put(lineChartDTO.getObat4().getNamaObat(), arr);

            if (lineChartDTO.getObat5() != null)
                data.put(lineChartDTO.getObat5().getNamaObat(), arr);

            model.addAttribute("data", data);

            return "dashboard/chart/view-line-chart";
        } else {
            return notFoundError;
        }
    }

    @GetMapping("/chart/bar-obat")
    public String obatBarChartForm(Model model, Principal principal) {
        if (userService.isAdmin(principal)) {
            var barChartDTO = new BarChartDTO();
            List<ObatModel> obatList = obatService.getListObat();

            model.addAttribute("lineChartDTO", barChartDTO);
            model.addAttribute("obatList", obatList);

            return "dashboard/chart/form-bar-chart";
        } else {
            return notFoundError;
        }
    }

    @PostMapping("/chart/bar-obat")
    public String obatBarChartView(@ModelAttribute BarChartDTO barChartDTO, Model model, Principal principal) {
        if (userService.isAdmin(principal)) {
            Map<String, Integer> data = new LinkedHashMap<>();

            if (barChartDTO.getType().equals("Penjualan")) {

                if (barChartDTO.getObat1() != null)
                    data.put(barChartDTO.getObat1().getNamaObat(),
                            obatService.penjualanTotalObat(barChartDTO.getObat1()));

                if (barChartDTO.getObat2() != null)
                    data.put(barChartDTO.getObat2().getNamaObat(),
                            obatService.penjualanTotalObat(barChartDTO.getObat2()));

                if (barChartDTO.getObat3() != null)
                    data.put(barChartDTO.getObat3().getNamaObat(),
                            obatService.penjualanTotalObat(barChartDTO.getObat3()));

                if (barChartDTO.getObat4() != null)
                    data.put(barChartDTO.getObat4().getNamaObat(),
                            obatService.penjualanTotalObat(barChartDTO.getObat4()));

                if (barChartDTO.getObat5() != null)
                    data.put(barChartDTO.getObat5().getNamaObat(),
                            obatService.penjualanTotalObat(barChartDTO.getObat5()));

                if (barChartDTO.getObat6() != null)
                    data.put(barChartDTO.getObat6().getNamaObat(),
                            obatService.penjualanTotalObat(barChartDTO.getObat6()));

                if (barChartDTO.getObat7() != null)
                    data.put(barChartDTO.getObat7().getNamaObat(),
                            obatService.penjualanTotalObat(barChartDTO.getObat7()));

                if (barChartDTO.getObat8() != null)
                    data.put(barChartDTO.getObat8().getNamaObat(),
                            obatService.penjualanTotalObat(barChartDTO.getObat8()));

                model.addAttribute("data", data);
                model.addAttribute("title", "Bar Chart Total Kuantitas Penjualan");

            } else if (barChartDTO.getType().equals("Pendapatan")) {

                if (barChartDTO.getObat1() != null)
                    data.put(barChartDTO.getObat1().getNamaObat(),
                            obatService.pemasukanTotalObat(barChartDTO.getObat1()).intValue());

                if (barChartDTO.getObat2() != null)
                    data.put(barChartDTO.getObat2().getNamaObat(),
                            obatService.pemasukanTotalObat(barChartDTO.getObat2()).intValue());

                if (barChartDTO.getObat3() != null)
                    data.put(barChartDTO.getObat3().getNamaObat(),
                            obatService.pemasukanTotalObat(barChartDTO.getObat3()).intValue());

                if (barChartDTO.getObat4() != null)
                    data.put(barChartDTO.getObat4().getNamaObat(),
                            obatService.pemasukanTotalObat(barChartDTO.getObat4()).intValue());

                if (barChartDTO.getObat5() != null)
                    data.put(barChartDTO.getObat5().getNamaObat(),
                            obatService.pemasukanTotalObat(barChartDTO.getObat5()).intValue());

                if (barChartDTO.getObat6() != null)
                    data.put(barChartDTO.getObat6().getNamaObat(),
                            obatService.pemasukanTotalObat(barChartDTO.getObat6()).intValue());

                if (barChartDTO.getObat7() != null)
                    data.put(barChartDTO.getObat7().getNamaObat(),
                            obatService.pemasukanTotalObat(barChartDTO.getObat7()).intValue());

                if (barChartDTO.getObat8() != null)
                    data.put(barChartDTO.getObat8().getNamaObat(),
                            obatService.pemasukanTotalObat(barChartDTO.getObat8()).intValue());

                model.addAttribute("data", data);
                model.addAttribute("title", "Bar Chart Total Pendapatan");
            }

            return "dashboard/chart/view-bar-chart";
        } else {
            return notFoundError;
        }
    }
}
