<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script type="text/javascript">

function ${pagingVO.funcName }(page){
	$("[name='searchForm']").find("[name='page']").val(page);
	$("[name='searchForm']").find("[name='what']").val($('#bodylist').find("td").eq(1).text()); 
	$("[name='searchForm']").submit();
}
	
function makeList(data){
	var navTag = $('#navtag');
	var bodyTag = $('#bodylist');
	var body="";
	var regex = /^(\s+)/;
	var packList = data.dataList;
	if(packList){
		$.each(packList,function(i, pack){
			var testArray = regex.exec(pack.package_reservation_list_name);
			if(testArray && testArray.length > 0){
				console.log(pack.package_reservation_list_name+"--"+testArray[1]+"-");
				pack.package_reservation_list_name = pack.package_reservation_list_name.replace(regex, Array(testArray[1].length).join("&nbsp;"));
			}
			body+="<tr><td>"+pack.rnum+"</td>";
			body+="<td>"+pack.package_reservation_no+"</td>";
			body+="<td>"+pack.mem_id+"</td>";
			body+="<td>"+pack.package_reservation_list_name+"</td>";
			body+="<td>"+pack.package_reservation_list_tel+"</td>";
			body+="<td>"+pack.package_reservation_list_gend+"</td></tr>";
			
		})
	}else{
		body+="<tr><td colspan='7'>데이터없음</td></tr>";
	}
	navTag.html(data.pagingHTML);
	bodyTag.html(body);
}	
	
$(function(){
  	var navTag = $('#navtag');
	var bodyTag = $('#bodylist');
	var searchForm = $('[name="searchForm"]');
	
	//뒤로가기
	$(window).on("popstate", function(event){
		console.log(event);
		if(event.originalEvent.state){
			var pagingVO = event.originalEvent.state;
			makeList(pagingVO);
		}else{
			location.reload();
		}
	});
	
	//submit 결과를 ajaxForm이 가져옴
	searchForm.ajaxForm({ 
	       dataType:  'json', 
	       success:  function (data){
			makeList(data);
			// 비동기 처리 성공 -> push state on history (state, title, url)
			var pageNum = searchForm.find('[name="page"]').val();
			var queryString = searchForm.serialize();
			
			history.pushState(data, pageNum+" 페이지", "?"+queryString);
			searchForm.find('[name="page"]').val("");
		},
	 });
	 
})

</script>
<div id="wrapper">
        <div id="page-wrapper">
<table class="table table-bordered table-striped table-hover">
	<thead class="thead-dark">
		<tr>
			<th>순번</th>
			<th>패키지 예약 번호</th>
			<th>패키지 예약 대표자ID</th>
			<th>패키지 예약자 명</th>
			<th>패키지 예약자 번호</th>
			<th>패키지 예약자 성별</th>
		</tr>
	</thead>
	<tbody id="bodylist">
		<c:choose>
			<c:when test="${not empty pagingVO.dataList }">
				<c:forEach items="${pagingVO.dataList }" var="pack">
					<tr>
						<td>${pack.rnum }</td>
						<td>${pack.package_reservation_no}</td>
						<td>${pack.mem_id}</td>
						<td>${pack.package_reservation_list_name}</td>
						<td>${pack.package_reservation_list_tel}</td>
						<td>${pack.package_reservation_list_gend}</td>
					</tr>
				</c:forEach>
			</c:when>
			<c:otherwise>
				<tr>
					<td colspan="7">검색 조건에 맞는 글이 없음.</td>
				</tr>
			</c:otherwise>
		</c:choose>
	</tbody>
	<tfoot>
		<tr>
			<td colspan="7" class="text-center">
				<nav aria-label="Page navigation" id="navtag">
				 	${pagingVO.pagingHTML } 
				</nav>
				
				<form action="<c:url value="/cor/reservationMemberView.do"/>" name="searchForm" class="form-inline justify-content-center">
					<input type="hidden" name="page" />
					<input type="hidden" name="what" />
					<select class="form-control" name="searchType">
						<option value="">전체</option>
						<option value="list_name">예약자 명</option>
					</select>
					<script type="text/javascript">
						$('[name="searchType"]').val("${param.searchType}");
					</script>
					<input class="form-control" type="text" name="searchWord" 
							value="${param.searchWord }"/>
					<input class="btn btn-success" type="submit" value="검색" />
					&nbsp;&nbsp;&nbsp;
				</form>
			</td>
		</tr>
	</tfoot>
</table>
</div>
</div>