<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thống Kê Doanh Thu - Shopee Style</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    
    <style>
        body {
            background-color: #fffaf7;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.08);
        }
        .card-header {
            background-color: #ee4d2d;
            color: white;
            border-top-left-radius: 16px !important;
            border-top-right-radius: 16px !important;
        }
        .btn-primary {
            background-color: #ee4d2d;
            border: none;
        }
        .btn-primary:hover {
            background-color: #d93c1c;
        }
        .alert-success {
            background-color: #fff3e0;
            color: #d35400;
            border: 1px solid #f5cba7;
        }
        table thead {
            background-color: #ee4d2d;
            color: white;
        }
        footer {
            background-color: #f8f9fa;
            text-align: center;
            padding: 10px;
            margin-top: 40px;
            border-top: 1px solid #ddd;
        }
    </style>

    <!-- Google Charts -->
    <script src="https://www.gstatic.com/charts/loader.js"></script>
    <script>
        google.charts.load('current', { packages: ['corechart', 'bar'] });
        google.charts.setOnLoadCallback(drawChart);

        function drawChart() {
            var data = new google.visualization.DataTable();
            data.addColumn('string', 'Ngày');
            data.addColumn('number', 'Doanh Thu');

            data.addRows([
                <c:forEach begin="1" end="${daysInMonth}" var="day">
                    ['Ngày ${day}', <c:out value="${dailyRevenueMap[day] != null ? dailyRevenueMap[day] : 0}" />],
                </c:forEach>
            ]);

            var options = {
                title: 'Doanh thu theo ngày (Tháng ${selectedMonth}/${selectedYear})',
                titleTextStyle: { color: '#ee4d2d', fontSize: 18, bold: true },
                legend: { position: 'none' },
                colors: ['#ee4d2d'],
                backgroundColor: '#fff',
                hAxis: { title: 'Ngày', textStyle: { color: '#333' }, slantedText: true },
                vAxis: { title: 'Doanh Thu (VND)', format: '###,###', textStyle: { color: '#333' } },
                bar: { groupWidth: '60%' }
            };

            var chart = new google.visualization.ColumnChart(document.getElementById('daily_revenue_chart'));
            chart.draw(data, options);
        }
    </script>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container mt-5">

    <!-- Bộ lọc -->
    <div class="card mb-4">
        <div class="card-header">
            <h3 class="mb-0"><i class="fa-solid fa-filter me-2"></i>Thống Kê Doanh Thu</h3>
        </div>
        <div class="card-body">
            <form action="statistic" method="get" class="row g-3 align-items-end mb-4">
                <div class="col-md-5">
                    <label for="selectedMonth" class="form-label fw-semibold">Chọn Tháng</label>
                    <select id="selectedMonth" name="selectedMonth" class="form-select">
                        <c:forEach begin="1" end="12" var="m">
                            <option value="${m}" ${m == selectedMonth ? 'selected' : ''}>Tháng ${m}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-5">
                    <label for="selectedYear" class="form-label fw-semibold">Chọn Năm</label>
                    <select id="selectedYear" name="selectedYear" class="form-select">
                        <c:set var="currentYear" value="<%= java.time.LocalDate.now().getYear() %>" />
                        <c:forEach begin="0" end="4" var="y">
                            <c:set var="yearValue" value="${currentYear - y}" />
                            <option value="${yearValue}" ${yearValue == selectedYear ? 'selected' : ''}>Năm ${yearValue}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fa-solid fa-chart-line me-1"></i> Xem
                    </button>
                </div>
            </form>

            <div class="alert alert-success text-center mt-4">
                <h4 class="alert-heading">Tổng Doanh Thu (Tháng ${selectedMonth}/${selectedYear})</h4>
                <p class="display-6 fw-bold">
                    <fmt:formatNumber value="${totalMonthRevenue}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                </p>
            </div>
        </div>
    </div>

    <!-- Biểu đồ cột -->
    <div class="card mb-4">
        <div class="card-header">
            <h4 class="mb-0"><i class="fa-solid fa-chart-column me-2"></i>Biểu Đồ Doanh Thu Theo Ngày</h4>
        </div>
        <div class="card-body">
            <div id="daily_revenue_chart" style="width:100%; height:450px;"></div>
        </div>
    </div>

    <!-- Sản phẩm bán chạy -->
    <div class="card">
        <div class="card-header">
            <h4 class="mb-0">Sản Phẩm Bán Chạy (Tháng ${selectedMonth}/${selectedYear})</h4>
        </div>
        <div class="card-body">
            <table class="table table-striped table-hover align-middle">
                <thead>
                    <tr>
                        <th scope="col">#</th>
                        <th scope="col">Tên Sản Phẩm</th>
                        <th scope="col" class="text-center">Tổng Số Lượng Đã Bán</th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${empty statisticList}">
                        <tr>
                            <td colspan="3" class="text-center">Chưa có dữ liệu.</td>
                        </tr>
                    </c:if>
                    <c:forEach items="${statisticList}" var="item" varStatus="loop">
                        <tr>
                            <th scope="row">${loop.count}</th>
                            <td>${item.productName}</td>
                            <td class="text-center">${item.totalSold}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

</div>

<jsp:include page="footer.jsp" />



</body>
</html>
