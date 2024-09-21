$(document).ready(function () {
  const folders = [
    "1987",
    "1988",
    "1989",
    "1990",
    "1991",
    "1992",
    "1993",
    "1994",
    "1995",
    "1996",
    "1997",
    "1998",
    "1999",
    "2000",
    "2001",
    "2002",
    "2003",
    "2004",
    "2005",
    "2006",
    "2007",
    "2008",
    "2009",
    "2010",
    "2011",
    "2012",
    "2013",
    "2014",
    "2015",
    "2016",
    "2017",
    "2018",
    "2019",
    "2020",
    "2021",
    "2022",
    "2023",
    "2024",
  ]; // Years
  const basePath = "assets/images/";
  let imagesArray = [
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
  ];

  // Function to get a random folder (year)
  function getRandomFolder() {
    const randomIndex = Math.floor(Math.random() * folders.length);
    return folders[randomIndex];
  }

  // Function to get a random image from the pool of images
  function getRandomImage() {
    const randomIndex = Math.floor(Math.random() * imagesArray.length);
    const result = imagesArray[randomIndex];
    imagesArray.splice(randomIndex, 1); // Remove used image from the array
    return result;
  }

  // Function to load images into the 4 image containers from the random folder
  function loadImages() {
    const randomFolder = getRandomFolder();

    // Save the random folder in the global scope to check later when guessing
    window.randomFolder = randomFolder;

    for (let i = 1; i <= 4; i++) {
      const imageName = getRandomImage();
      const imageUrl = `${basePath}${randomFolder}/${imageName}.jpg`; // Adjust the naming convention as needed
      $(`#img${i}`).html(
        `<img src="${imageUrl}" class="img-fluid rounded" alt="${imageName}">`
      );
    }

    // Reset result message
    $("#yearInput").val("");
    $("#yearInput").focus();
  }

  // Start the game by loading random images initially
  loadImages();

  // Event handler for the "Guess the Year" button
  $("#guessYearBtn").on("click", function () {
    const guessedYear = $("#yearInput").val(); // Get the entered year

    let resultMessage = "";
    if (guessedYear === window.randomFolder) {
      resultMessage = '<p class="text-success">That is correct! Well done!</p>';
    } else {
      resultMessage = `<p class="text-danger">Wrong! The correct year was <strong>${window.randomFolder}</strong>.</p>`;
    }

    $("#resultMessage").html(resultMessage);
    const modal = new bootstrap.Modal(document.getElementById("resultModal"));
    modal.show(); // Show the result modal
  });

  // Event handler for the "Play Again" button in the modal
  $("#restartBtn").on("click", function () {
    imagesArray = [
      "0",
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "10",
      "11",
      "12",
      "13",
      "14",
      "15",
      "16",
      "17",
      "18",
      "19",
    ]; // Reset image pool
    $("#resultModal").modal("hide"); // Close the modal
    loadImages(); // Restart the game by loading new images
  });

  // Listen for Enter keypress on the input field
  $(document).on("keydown", function (e) {
    if (e.key === "Enter") {
      e.preventDefault(); // Prevent form submission or default action

      // Check if the modal is visible
      if ($("#resultModal").hasClass("show")) {
        // If modal is open, restart the game
        $("#restartBtn").click();
      } else {
        // If modal is not open, submit the guess
        $("#guessYearBtn").click();
      }
    }
  });
});
