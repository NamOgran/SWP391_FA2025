
    const editInfoBtn = document.querySelectorAll('.edit-info-btn');
    const dropdownContainer = document.querySelectorAll('.dropdown-container');
  
    editInfoBtn.forEach(function (edit, i) {
        edit.addEventListener('click', function () {
           
            if (dropdownContainer[i].style.display === "none") {
                dropdownContainer[i].style.display = "block";
            } else {
                dropdownContainer[i].style.display = "none";
            }

        });
    });





