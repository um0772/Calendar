<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang='en'>
<head>
  <title>DB ProJect~ 초심</title>
  <meta charset='utf-8' />
  <link href="${pageContext.request.contextPath}/FullCalendar/lib/main.css" rel="stylesheet" />
  <script src="${pageContext.request.contextPath}/FullCalendar/lib/main.js"></script>
  <script src='FullCalendar/lib/locales/ko.js'></script>
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      var calendarEl = document.getElementById('calendar');
      var calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'dayGridMonth',
        locale: 'ko',
        dateClick: function(info) {
          var clickedDate = info.dateStr;
          var modal = document.createElement('div');
          modal.innerHTML = `
            <div id="myModal" class="modal">
                <div class="modal-content">
                  <div class="first"></div>
                    <div class="middle">
                      <div class="modal-top">
                        <span class="close">&times;</span>
                        <p>일정 추가 ${clickedDate}</p>
                      </div>
                      <div class = "modal-body">
                        <div class = "body-title">
                          <input type="text" id="eventTitle" placeholder="일정 제목">
                        </div>
                        <div class = "body-sub">
                          <input type="text" id="eventDescription" placeholder="설명">
                        </div>
                      </div>
                      <div class="modal-bottom">
                        <button id="addEventBtn">일정 추가</button>
                      </div>
                    </div>
                    <div class="end"></div>
                </div>
            </div>
          `;
          document.body.appendChild(modal);

          var modalClose = modal.querySelector('.close');
          modalClose.onclick = function() {
            document.body.removeChild(modal);
          };

          var addEventBtn = modal.querySelector('#addEventBtn');
          addEventBtn.onclick = function() {
            var eventTitle = modal.querySelector('#eventTitle').value;
            var eventDescription = modal.querySelector('#eventDescription').value;
            var event = {
              title: eventTitle,
              start: clickedDate,
              allDay: true,
              description: eventDescription // 설명 추가
            };
            calendar.addEvent(event);
            document.body.removeChild(modal);
          };
        },
        eventClick: function(info) {
          var clickedEvent = info.event;
          var eventTitle = clickedEvent.title;
          var eventDescription = clickedEvent.extendedProps.description || ''; // 기존 설명
          var modal = document.createElement('div');
          modal.innerHTML = `
            <div id="myModal" class="modal">
              <div class="modal-content">
                <span class="close">&times;</span>
                <p>일정 수정 ${eventTitle}</p>
                <input type="text" id="eventTitle" placeholder="일정 제목" value="${eventTitle}">
                <input type="text" id="eventDescription" placeholder="일정 설명" value="${eventDescription}">
                <button id="updateEventBtn">일정 수정</button>
              </div>
            </div>
          `;
          document.body.appendChild(modal);

          var modalClose = modal.querySelector('.close');
          modalClose.onclick = function() {
            document.body.removeChild(modal);
          };

          var updateEventBtn = modal.querySelector('#updateEventBtn');
          var titleInput = modal.querySelector('#eventTitle');
          var descriptionInput = modal.querySelector('#eventDescription');

          titleInput.value = eventTitle;
          descriptionInput.value = eventDescription;

          updateEventBtn.onclick = function() {
            var newEventTitle = titleInput.value;
            var newEventDescription = descriptionInput.value;
            clickedEvent.setProp('title', newEventTitle);
            clickedEvent.setExtendedProp('description', newEventDescription); // 설명 업데이트
            document.body.removeChild(modal);
          };
        },
        eventDidMount: function(info) {
          var description = info.event.extendedProps.description;
          if (description) {
            var descriptionEl = document.createElement('div');
            descriptionEl.className = 'fc-event-description';
            descriptionEl.innerHTML = description;
            info.el.querySelector('.fc-event-title').appendChild(descriptionEl);
          }
        }
      });
      calendar.render();
    });

  </script>
  <style>
    html, body {
      min-height: 100%;
      margin: 0;
      padding: 0;
      position: relative;
    }
    /* 모달 스타일 */
    .modal {
      position: absolute;
      z-index: 1;
      display: grid;
      place-items: center;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      overflow: auto;
      background-color: rgba(0, 0, 0, 0.4);


    }
    .modal-content {
      height: 60%;
      width: 100%;
      display: flex;
      flex-direction: row;


    }

    .first {
      height: 40%;

      width: 20%;
    }
    .end {
      height: 40%;
      width: 20%;
    }
    .middle {
      position: relative;
      flex-direction: column;
      display: flex;
      height: 60%;
      width: 60%;

    }

    .modal-top {
      top: 0;
      flex: 1;
      background-color: #3788d8;
      height: 10%;
      width: 100%;
      text-align: center;
      position: absolute;
    }
    .modal-body {

      align-items: center;
      justify-content: center;
      display: flex;
      flex-direction: column;
      width: 100%;
      height: 50%;
      background-color: bisque;
    }
    .close {
      cursor: pointer; /* 마우스 오버 시 커서 변경 */
      position: absolute;
      top: 10px;
      right: 10px;
      font-size: 24px;
      color: #fff;
    }
    .body-title {
      display: flex;
      width: 100%;
      align-items: center;
      justify-content: center;
    }
    #eventTitle {
      width: 80%;
    }
    .body-sub {
      width: 100%;
      display: flex;
      align-items: center;
      justify-content: center;

    }
    #eventDescription {
      width: 80%;
      height: 60px;
    }

    .modal-bottom {
      flex: 1;
      width: 100%;
      bottom: 0;
      position: absolute;
      height: 10%;

    }
    #addEventBtn {
      height: 10%;
    }
  </style>
</head>
<body>
<div id='calendar'></div>
</body>
</html>