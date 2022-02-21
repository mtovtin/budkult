document.addEventListener("DOMContentLoaded", function () {
    // конфигурация чат-бота
    const configChatbot = {};
    // CSS-селектор кнопки, посредством которой будем вызывать окно диалога с чат-ботом
    configChatbot.btn = '.chatbot__btn';
    // ключ для хранения отпечатка браузера
    configChatbot.key = 'fingerprint';
    // реплики чат-бота
    configChatbot.replicas = '/chat_cfg';
    // корневой элемент
    configChatbot.root = SimpleChatbot.createTemplate();
    // URL chatbot.php
    configChatbot.url = '/chat';
    // переменная для хранения экземпляра
    let chatbot = null;
    // добавление ключа для хранения отпечатка браузера в LocalStorage
    let fingerprint = localStorage.getItem(configChatbot.key);
    if (!fingerprint) {
        Fingerprint2.get(function (components) {
            fingerprint = Fingerprint2.x64hash128(components.map(function (pair) {
                return pair.value
            }).join(), 31)
            localStorage.setItem(configChatbot.key, fingerprint)
        });
    }
    // при клике по кнопке configChatbot.btn
    document.querySelector(configChatbot.btn).onclick = function (e) {
        this.classList.add('d-none');
        const $tooltip = this.querySelector('.chatbot__tooltip');
        if ($tooltip) {
            $tooltip.classList.add('d-none');
        }
        configChatbot.root.classList.toggle('chatbot_hidden');
        if (chatbot) {
            return;
        }
        // получение json-файла, содержащего сценарий диалога для чат-бота через AJAX
        const request = new XMLHttpRequest();
        request.open('GET', configChatbot.replicas, true);
        request.responseType = 'json';
        request.onload = function () {
            const status = request.status;
            if (status === 200) {
                const data = request.response;
                // для поддержки IE11
                if (typeof data === 'string') {
                    configChatbot.replicas = JSON.parse(data);
                } else {
                    configChatbot.replicas = data;
                }
                // инициализация SimpleChatbot
                chatbot = new SimpleChatbot(configChatbot);
                chatbot.init();
            } else {
                console.log(status, request.response);
            }
        };
        request.send();
    };
});