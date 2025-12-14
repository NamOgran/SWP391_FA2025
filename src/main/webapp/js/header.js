

function redirectCartPage() {
    window.location.href = "/cart.html";
}

function toggleBox(boxId) {
    var box = document.getElementById(boxId);
    var boxes = document.querySelectorAll('.box');

    // Tắt tất cả các box
    boxes.forEach(function(item) {
        if (item.id !== boxId) {
            item.style.display = 'none';
        }
    });

    // Hiển thị hoặc ẩn box tương ứng
    if (box.style.display === 'block') {
        box.style.display = 'none';
    } else {
        box.style.display = 'block';
    }
}

// var boxes = document.querySelectorAll('.box');

// // Lấy tất cả các icon
// var icons = document.querySelectorAll('.icon');

// // Xử lý sự kiện click trên document
// document.addEventListener('click', function (event) {
//     var clickedElement = event.target;

//     // Kiểm tra nếu là icon được nhấp
//     if (clickedElement.classList.contains('icon')) {
//         var boxId = clickedElement.getAttribute('id').replace('icon', 'box');
//         var box = document.getElementById(boxId);

//         // Hiển thị box tương ứng
//         box.style.display = 'block';

//         // Ẩn tất cả các box khác
//         boxes.forEach(function (box) {
//             if (box !== document.getElementById(boxId)) {
//                 box.style.display = 'none';
//             }
//         });
//     } else {
//         // Nếu không phải là icon, ẩn tất cả các box
//         boxes.forEach(function (box) {
//             box.style.display = 'none';
//         });
//     }
// });



