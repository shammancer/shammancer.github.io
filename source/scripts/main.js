document.addEventListener('DOMContentLoaded', () => {
    const h2 = document.querySelector('header h2');
    if (!h2 || !h2.textContent.trim()) return;

    const text = h2.textContent;
    const cursor = document.createElement('span');
    cursor.className = 'typewriter-cursor';
    cursor.textContent = '█';

    h2.textContent = '';
    h2.appendChild(cursor);

    let i = 0;
    const interval = setInterval(() => {
        h2.insertBefore(document.createTextNode(text[i]), cursor);
        i++;
        if (i >= text.length) {
            clearInterval(interval);
        }
    }, 60);
});
