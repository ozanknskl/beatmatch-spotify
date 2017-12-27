
var playingCssClass = 'playing',
audioObject = null;

results.addEventListener('click', function (e) {
var target = e.target;
if (target !== null && target.classList.contains('cover')) {
    if (target.classList.contains(playingCssClass)) {
        audioObject.pause();
    } else {
        if (audioObject) {
            audioObject.pause();
        }
   
        audioObject = new Audio(target.getAttribute('data-preview-url'));
        audioObject.play();
        target.classList.add(playingCssClass);
        audioObject.addEventListener('ended', function () {
            target.classList.remove(playingCssClass);
        });
        audioObject.addEventListener('pause', function () {
            target.classList.remove(playingCssClass);
        });
    }
}
});
