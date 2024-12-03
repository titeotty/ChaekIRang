<!--<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>-->
<%@ page import="java.util.ArrayList,book.BookInfo,userinfo.UserDAO" %>
<!DOCTYPE html>
<html>
<head>
 	<meta charset="UTF-8" />
 	<link rel="stylesheet" href="<%=request.getContextPath()%>/css/searchResultPage.css" />
 	<link rel="stylesheet" href="<%=request.getContextPath()%>/css/default.css"/>
    <title>책이랑-책검색결과</title>
</head>
<%
	ArrayList<BookInfo> bookList = (ArrayList<BookInfo>) request.getAttribute("bookList");
	int size = bookList.size(); // 검색결과 갯수
	// 제목과 저자를 저장할 배열 선언
	String[] titles = new String[size];
	String[] authors = new String[size];
	String[] img = new String[size];
	boolean[] isEbook = new boolean[size];
	int[] price = new int[size];
	String[] description = new String[size];
	String[] buyLink = new String[size];
	// bookList가 null이 아니고, 비어있지 않다면
	if (bookList != null && !bookList.isEmpty()) {
	    // bookList를 순회하면서 배열에 데이터 저장
	    for (int i = 0; i < size; i++) {
	        BookInfo book = bookList.get(i);
	        titles[i] = book.getTitle();    // 제목 저장
	        authors[i] = book.getAuthors(); // 저자 저장
	        img[i] = book.getImg();
	        isEbook[i] = book.getIsEbook();
	        price[i] = book.getPrice();
	        description[i] = book.getDescription();
	        buyLink[i] = book.getBuyLink();
	    }
	}
	else { 
		UserDAO.alertAndBack(response, "검색 결과가 없습니다.");
	}
	
	// 그 버튼으로 검색결과 소트정렬
    String sortType = request.getParameter("sort");
    if (bookList != null && !bookList.isEmpty()) {
        if ("priceLow".equals(sortType)) {
            bookList.sort((b1, b2) -> Integer.compare(b1.getPrice(), b2.getPrice()));
        } else if ("priceHigh".equals(sortType)) {
            bookList.sort((b1, b2) -> Integer.compare(b2.getPrice(), b1.getPrice()));
        } else if ("name".equals(sortType)) {
            bookList.sort((b1, b2) -> b1.getTitle().compareToIgnoreCase(b2.getTitle()));
        }
     	// 소트를 거친 배열로 초기화
        for (int i = 0; i < size; i++) {
            BookInfo book = bookList.get(i);
            titles[i] = book.getTitle();
            authors[i] = book.getAuthors();
            img[i] = book.getImg();
            isEbook[i] = book.getIsEbook();
            price[i] = book.getPrice();
            description[i] = book.getDescription();
            buyLink[i] = book.getBuyLink();
        }
    }
	
	int currentPage = 1;
	if (request.getParameter("page") != null) {
		currentPage = Integer.parseInt(request.getParameter("page"));
	}
	
	int booksPerPage = 5; // 한 페이지에 표시할 책의 수
	int totalPages = (int) Math.ceil(size / (double) booksPerPage); // 전체 페이지 수
	
	String searchWord = request.getParameter("search");
	if (searchWord == null) {
		searchWord = ""; // 기본값으로 빈 문자열
	}
	// 반복문 시작인덱스 끝인덱스
	int startIndex = (currentPage - 1) * booksPerPage;
    int endIndex = Math.min(startIndex + booksPerPage, size);
%>


<body>
  <div class="div-wrapper">
    <div class="div">
	  <%@ include file="../modules/headerSearch.jsp" %>
	  
	  <div class="searchresult-page">
	      <div class="sidebar">
	      	<div class="discuss-recommend">
	      		<p>이런 토론 주제는 어떠세요?</p>
	      		<div class="recommend-first"></div>
	      		<div class="recommends"></div>
	      		<div class="recommends"></div>
	      	</div>
	      </div>
	      
	      <div class="search-result">
	      	<div class="search-result-header">
	      		<p class="result-count"><%= size %>개의 검색 결과가 있습니다.</p>
	      		<div class="sort">
				    <a href="?page=<%= currentPage %>&search=<%= searchWord %>&sort=priceLow" 
				       class="<%= "priceLow".equals(sortType) ? "active" : "" %>">낮은 가격순</a>
				    <a href="?page=<%= currentPage %>&search=<%= searchWord %>&sort=priceHigh" 
				       class="<%= "priceHigh".equals(sortType) ? "active" : "" %>">높은 가격순</a>
				    <a href="?page=<%= currentPage %>&search=<%= searchWord %>&sort=name" 
				       class="<%= "name".equals(sortType) ? "active" : "" %>">이름순</a>
				</div>
	      	</div>
	      	<div class="result-contents">
	      		<% for(int count = startIndex; count < endIndex; count++){ %>
	      		<div class="result-bookinfo">
	      			<a href=<%=buyLink[count] %> target="_blank">
	      			<img src=<%= img[count] %> alt=<%= titles[count] %> />
	      			</a>
	      			<div>
	      				<p class="title"><%= titles[count] %></p>
	      				<p class="author">저자 : 
	      				<%= (authors[count] != null && authors[count].length() > 0) 
					        ? String.join(", ", authors[count]).replaceAll("\"", "").replaceAll("[\\[\\]\"]", "")
					        : "정보 없음" 
					    %></p>
	      				<p class="price">가격 : <%=price[count] %>원</p>
	      				<p class="description">
	      				<%= description[count] != null && description[count].length() > 0
					        ? (description[count].length() > 120 
					            ? description[count].substring(0, 120) + "..." 
					            : description[count])
					        : "정보 없음"
					    %></p>
	      			</div>
	      		</div>
	      		<% } %>
	      	</div>
	      	<!-- 페이지 네비게이션 -->
	      	<div class="pagination">
			   <% for (int i = 1; i <= totalPages; i++) { %>
	      			<a href="?page=<%= i %>&search=<%= searchWord %>&sort=<%= sortType %>" <%= (i == currentPage ? "class='active'" : "") %>><%= i %></a>
	      		<% } %>
			</div>
	      </div>
      </div>
      
	  <%@ include file="../modules/footer.jsp" %>
	</div>
  </div>
</body>
</html>
