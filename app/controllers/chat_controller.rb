class ChatController < CamaleonCms::FrontendController
  skip_before_action :verify_authenticity_token
  # ported from php (SimpleChatBot)
  def chat
    data = params.as_json
    client_id = data['id']
    chat, start, date = data['chat'], data['start'], data['date']
    chat_path = "chats/"
    file_name = "#{client_id}"
    file_name

    if not Dir.exist?("#{Rails.root}/log/#{chat_path}")
      Dir.mkdir("#{Rails.root}/log/#{chat_path}")
    end

    chat_logger ||= Logger.new("#{Rails.root}/log/#{chat_path}#{file_name}.json")
    chat_logger.formatter = proc do |severity, datetime, progname, msg|
      "#{msg}"
    end
    chat.map do |e|
      date = DateTime.now.strftime("%Y-%m-%d %H:%M:%S")
      chat_logger.info(JSON.dump(date: "#{date}", who: "#{e[1]['type']}", message: "#{e[1]['content']}") + ",\n")
    end
  end

  # chat-bot configuration
  # originally stored in a separate json-file
  # or directly included into the page
  def chat_config
    render json: {
      "bot": {
        "0": {
          "content": [
            "Добрий день! Я чат-бот сайту, як мені до Вас звертатись?"
          ],
          "human": [3,]
        },
        #"1": { "content": "Я теж радий, як мені до Вас звертатись?", "human": [3] },
        "2": { "content": "як мені до Вас звертатись?", "human": [3] },
        "3": { "content": "{{name}}, Що Вас цікавить?", "human": [4, 7, 8, 9, 10, 11] },
        "4": { "content": " Можливо Вас цікавить?", "human": [4.1, 4.2, 4.3, 4.4, 4.5, 4.6, 4.7, 6] },
        "4.1": { "content": " Ви можете вибрати зручний час <br/> для візиту в ЦНАП записавшись онлайн <a href=\"https://cnap.rada-uzhgorod.gov.ua/main/home/onlinequeue\" target=\"_blank\">за цим посиланням</a>, 
               <br/> або за номером телефону <a href=\"tel:+380312428028\">+380312428028</a>", "human": [4, 6] }, 
        "4.2": { "content": "На порталі Адміністративних послуг м. Ужгорода <br/> Ви можете ознайомитись з послугами, які надаються ЦНАП <a href=\"https://cnap.rada-uzhgorod.gov.ua\" target=\"_blank\">за цим посиланням</a>", "human": [4, 6]  },
        "4.3": { "content": "Понеділок, вівторок, четвер – з 8.30 до 16.00, <br/> санітарне прибирання з 12.00 до 12.30. <br/>  Середа – з 9.30 до 20.00, санітарне прибирання з 12.00 до 12.30. <br/>
                П'ятниця, Субота – з 8.30 до 14.00, без перерви. <br/> Вихідний день – неділя", "human": [4, 6] },
        "4.4": { "content": "На порталі <a href=\"https://cnap.rada-uzhgorod.gov.ua/main/home/onlinequeue\" target=\"_blank\">Адміністративних послуг м. Ужгорода </a> 
                 <br/> оберіть послугу та перейдіть <br/> в розділ «необхідні документи, шаблон», завантажте заяву та інформаційну картку з переліком документів", "human": [4, 6] },
        "4.5": { "content": "Замовити адміністративні послуги, що надаються онлайн Ви можете <a href=\" https://cnap.rada-uzhgorod.gov.ua/info/services\" target=\"_blank\">за цим посиланням</a>", "human": [4, 6] },
        "4.6": { "content": "Консультацію щодо роботи/адмінпослуг ЦНАП можна отримати за номером телефону <a href=\"tel:+380312428028\">+380312428028</a>", "human": [4, 6] },
        "4.7": { "content": "В розділі <a href=\" https://cnap.rada-uzhgorod.gov.ua/main/home/uzgorodservicestate\" target=\"_blank\">«Перевірка виконання послуги»</a>  <br/>
                вводите номер заначений під штрих-кодом,  <br/> з «Талону про реєстрацію адміністративної послуги»   <br/> отриманому під час подачі заяви до ЦНАП", "human": [4, 6] },
        "5": {  },
        "6": { "content": "", "human": [] },
        "7": { "content": "Можливо Вас цікавить?", "human": [7.1, 7.2, 7.3, 6] },
        "8": { "content": "Можливо Вас цікавить?", "human": [8.1, 8.2, 6] },
        "8.1": { "content": "На сайті Ужгородської міської ради у розділі Міста-побратими <a href=\"https://rada-uzhgorod.gov.ua/mista-pobratymy\" target=\"_blank\">за цим посиланням</a>", "human": [6] },
        "8.2": { "content": "На сайті Ужгородської міської ради у розділі Транскордонне співробітництво 
        <a href=\"https://rada-uzhgorod.gov.ua/transkordonna-spivpratsya\" target=\"_blank\">за цим посиланням.</a>", "human": [6] },
        "9": { "content": "Можливо Вас цікавить?", "human": [9.1, 9.2, 9.3, 9.4, 9.5, 9.6, 9.7, 9.8, 9.9, 9.10, 9.11, 9.12, 9.13, 9.14, 9.15, 9.16, 9.17, 6] },
        "9.1": { "content": "Форма повідомлення про початок виконання будівельних робіт, <br/> порядок його подання, визначаються <br/>
              <a href=\"https://zakon.rada.gov.ua/laws/show/466-2011-%D0%BF#Text\" target=\"_blank\">Постановою КМ України №466 13.04.2011 р.</a> <br/> 
              <a href=\"https://zakon.rada.gov.ua/laws/file/text/92/f351247n829.docx\" target=\"_blank\">ПОВІДОМЛЕННЯ щодо виконання підготовчих робіт на об’єкті</a><br/>
              <a href=\"https://zakon.rada.gov.ua/laws/file/text/92/f351247n830.docx\" target=\"_blank\">ПОВІДОМЛЕННЯ про початок виконання будівельних робіт щодо об’єктів, будівництво яких здійснюється на підставі будівельного паспорта</a><br/>
              <a href=\"https://zakon.rada.gov.ua/laws/file/text/92/f351247n831.docx\" target=\"_blank\">ПОВІДОМЛЕННЯ про початок виконання будівельних робіт на об’єктах з незначними наслідками (СС1)</a> ",  "human": [6, 9] },
        "9.2": { "content": "Форма декларації визначаються 
              <a href=\"https://zakon.rada.gov.ua/laws/show/461-2011-%D0%BF#n74\" target=\"_blank\">Постановою КМ України №461 13.04.2011р.</a> <br/>
              <a href=\"https://zakon.rada.gov.ua/laws/file/text/91/f350670n440.docx\" target=\"_blank\">ДЕКЛАРАЦІЯ про готовність до експлуатації об’єкта, будівництво якого здійснено на підставі будівельного паспорта</a> <br/>
              <a href=\"https://zakon.rada.gov.ua/laws/file/text/91/f350670n441.docx\" target=\"_blank\">ДЕКЛАРАЦІЯ про готовність до експлуатації об’єкта з незначними наслідками (СС1).</a>", "human": [6, 9] },
        "9.3": { "content": "Відповідно до Порядку проведення технічного обстеження і прийняття в експлуатацію індивідуальних будинків, забудов ... замовником (його уповноваженою особою) до відповідного органу ДАБК подається: <br/>
                1. заяву; <br/>
                2. один примірник заповненої декларації;<br/>
                3. звіт (крім випадків, передбачених <a href=\"https://zakon.rada.gov.ua/laws/show/z0976-18#n39\" target=\"_blank\">пунктом 5</a> розділу ІІ цього Порядку);<br/>
                4. засвідчені у встановленому законом порядку :<br/>
                - документа, що посвідчує право власності чи користування земельною ділянкою відповідного цільового призначення, на якій розміщено об’єкт;<br/>
                - технічного паспорта (з відміткою у випадках, передбачених пунктом 5 розділу II цього Порядку). ", "human": [6, 9] },
        "9.4": { "content": "Замовник подає до відповідного органу ДАБК повідомлення або декларацію за затвердженою формою з виправленими (достовірними) даними щодо інформації, яка потребує змін.", "human": [6, 9] },
        "9.5": { "content": "Згідно з Державним класифікатором будівель та споруд ДК018-2000, затверджений і введений в дію Наказом Держстандарту України від 17.08.2000 №507", "human": [6, 9] },
        "9.6": { "content": "Документи подаються за вибором замовника до відповідного органу ДАБК:<br/>
                1)	в електронній формі через електронний кабінет або іншу державну інформаційну систему, інтегровану з електронним кабінетом, 
                користувачами якої є замовник та відповідний орган державного архітектурно-будівельного контролю; <br/>
                2)	у паперовій формі або поштовим відправленням з описом вкладення через центри надання адміністративних послуг.", "human": [6, 9] },
        "9.7": { "content": "Індивідуальні (садибні) житлових будинків, садові, дачні будинки загальною площею до 300 квадратних метрів, <br/>
                а також господарських (присадибних) будівель і споруд загальною площею до 300 квадратних метрів, <br/>
                збудованих у період з 05 серпня 1992 року по 09 квітня 2015 року та  будівлі і споруд сільськогосподарського призначення, <br/>
                збудованих до 12 березня   2011 року, побудовані без дозвільних документів, можна здати в експлуатацію по спрощеній системі,<br/>
                шляхом оформлення декларації про готовність в порядку, затвердженим Наказом Мінрегіонбуду №158 03.07.2018р.", "human": [6, 9] },
        "9.8": { "content": "Старий реєстр ДАБІ було інтегровано до Єдиної системи в сфері будівництва як архівну складову, 
                він має таку ж юридичну силу, як і до того", "human": [6, 9] },
        "9.9": { "content": "В розділі інформація про замовника, заповнюються відповідні відомості, 
               та додатково на окремому аркуші заповнюється відомості на іншого замовника та подається, як додаток до основного документа", "human": [6, 9] },
        "9.10": { "content": "Зазначається інформація  про документ, який є підставою для виникнення  права власності або користування земельною ділянкою <br/>
                (договір купівлі-продажу, договір дарування, договір оренди, рішення міської ради  і т.д.)", "human": [6, 9] },
        "9.11": { "content": "Подання здійснюється виключно в електронній формі через електронний кабінет або іншу державну інформаційну систему, <br/>
                інтегровану з електронним кабінетом, користувачами якої є суб’єкт звернення та суб’єкт надання відповідної послуги. <br/>
                Для замовників будівництва подання документів для отримання адміністративних послуг на Порталі Дія   
                <a href=\"https://diia.gov.ua/services/categories/gromadyanam/zemlya-budivnictvo-neruhomist\" target=\"_blank\">за цим посиланням</a>", "human": [6, 9] },
        "9.12": { "content": "Для отримання сертифіката замовник (його уповноважена особа) подає до відповідного органу державного архітектурно-будівельного контролю <br/>
                заяву про прийняття в експлуатацію об’єкта та видачу сертифіката, до якої додається акт готовності об’єкта до експлуатації та документ або інформація (реквізити платежу) <br/>
                про внесення плати.  Акт готовності об’єкта формується виключно з використанням Реєстру будівельної діяльності електронної системи замовником в особистому кабінеті на порталі 
                <a href=\"https://admin.e-construction.gov.ua/dashboard\" target=\"_blank\">за цим посиланням</a>", "human": [6, 9] },
        "9.13": { "content": "На порталі <a href=\"https://e-construction.gov.ua/\" target=\"_blank\">державної електронної системи у сфері будівництва</a>
                в розділі Реєстри / декларативні та дозвільні документи / декларативні та дозвільні документи від 06.07.2020р. або декларативні та дозвільні документи до 06.07.2020р. 
                та вносите відповідний критерій пошуку", "human": [6, 9] },
        "9.14": { "content": "Інформація щодо переліку об’єктів, які перевірятимуться ДАБК у поточному році розміщена на офіційному сайті УМР
                <a href=\"https://rada-uzhgorod.gov.ua/prozoriy-dabk\" target=\"_blank\">за цим посиланням </a>", "human": [6, 9] },
        "9.15": { "content": "Постанова про накладення штрафів,  у сфері містобудівної діяльності, сплачується порушником через установу банку України. <br/>
                Відповідно до ст. 308 КУпАП у разі несплати правопорушником штрафу у встановлений строк, постанова про накладення штрафу надсилається для примусового <br/>
                виконання до органу державної виконавчої служби за місцем проживання порушника, роботи або за місцезнаходженням його майна.  <br/>
                Копія завіреного банком платіжного документа, що засвідчує факт сплати суми штрафу в повному обсязі, <br/>
                обов’язково надіслати на адресу управління: 88000, Закарпатська обл., м. Ужгород, вул. Небесної Сотні, 4,", "human": [6, 9] },
        "9.16": { "content": "Штраф підлягає сплаті у п’ятнадцятиденний строк з дня вручення або надсилання постанови рекомендованим листом з повідомленням про вручення,<br/>
                 а в разі оскарження такої постанови - не пізніш як через п’ятнадцять днів з дня повідомлення про залишення скарги без задоволення", "human": [6, 9] },
        "9.17": { "content": "Згідно з Законом України «Про регулювання містобудівної діяльності» виконання будівельних робіт без набуття права на їх виконання, <br/>
                тобто без наявності відповідного дозвільного документу – забороняється. За виконання будівельних робіт без дозволу на їх виконання тягнуть за собою накладення штрафу <br/>
                для фізичних осіб відповідно до ст. 96 КУпАП, а для юридичних осіб згідно з ст. 2 Закону України «Про відповідальність за правопорушення у сфері містобудівної діяльності». <br/>
                Разом з вищенаведеним звертаємо увагу, що правопорушнику видається обов’язковий до виконання пропис про усунення порушень", "human": [6, 9] },
        "10": { "content": "Можливо Вас цікавить?", "human": [10.1, 10.2, 10.3, 10.4, 6] },
        "10.1": { "content": "Для того, щоб передати об’єкт в оренду на аукціоні, його потрібно попередньо включити до переліку першого типу.
                Для того, щоб передати об’єкт в оренду без проведення аукціону, його потрібно попередньо включити до переліку другого типу.
                Якщо від потенційного орендаря надійде заявка на включення об’єкта до переліку 1 чи 2 типу, орендодавець, розглянувши заяву орендаря, включає майно у відповідний перелік. 
                Якщо від потенційного орендаря надійде заява на включення комунального майна до переліку 2 типу, то рішення про включення приймає місцева рада. Орендодавці, 
                балансоутримувачі та уповноважені органи управління також мають право ініціювати включення об’єкта до переліку.
                Щоб включити конкретний об’єкт до переліку 1 чи 2 типу орендодавцю, балансоутримувачу, і за необхідності, уповноваженому органу управління та органу культурної спадщини,
                потрібно прийняти відповідні рішення, що передбачені <a href=\"https://zakon.rada.gov.ua/laws/show/483-2020-%D0%BF#n36\" target=\"_blank\"> Порядком передачі в оренду державного та комунального майна </a> ", "human": [6, 10] },
        "10.2": { "content": "Відповідно до пункту 149 Порядку передачі в оренду державного та комунального майна, затвердженого постановою Кабінету Міністрів України від 03.06.2020 №483 
                чинний орендар має переважне право на продовження договору оренди в ході аукціону на продовження договору оренди за умови, що він бере участь в такому аукціоні та зробив закриту 
                цінову пропозицію, яка є не меншою, ніж розмір стартової орендної плати. Для реалізації переважного права чинний орендар надає згоду сплачувати орендну плату, що є рівною ціновій 
                пропозиції учасника, який подав найвищу цінову пропозицію за лот, після чого чинний орендар набуває статусу переможця аукціону на продовження договору оренди.
                У разі відмови чинного орендаря сплачувати таку орендну плату він може надати попередню згоду сплачувати орендну плату, що є рівною ціновій пропозицій учасника з наступною 
                за величиною ціновою пропозицією. Якщо чинний орендар погодився з наступною за величиною ціновою пропозицією, то він переходить до статусу очікування результату кваліфікації особи, яка подала найвищу цінову пропозицію.
                Згода надається в ході спеціального етапу аукціону шляхом натискання відповідної кнопки в електронній торговій системі. ", "human": [6, 10] },
        "10.3": { "content": "Підприємства, установи та організації як балансоутримувачі комунального майна мають право виступати орендодавцями нерухомого майна, 
                загальна площа якого не перевищує 400 квадратних метрів (не зважаючи на кількість приміщень або їх ізольованість) на одне підприємство, установу, організацію, без урахування площ, крім випадків,
                передбачених абзацами третім та четвертим пункту «г» частини другої статті 4 Закону України «Про оренду державного та комунального майна», коли балансоутримувачі можуть виступати орендодавцями без обмеження площі. ", "human": [6, 10] },
        "10.4": { "content": "Відповідно до частини третьої статті 4 Закону України «Про оренду державного та комунального майна» орендарями можуть бути фізичні та юридичні особи,
                 у тому числі фізичні та юридичні особи іноземних держав, міжнародні організації та особи без громадянства (крім передбачених частиною четвертою цієї статті).", "human": [6, 10] },
        "11": { "content": "Допомога ВПО", "human": [11.1, 6] },
        "11.1": { "content": "Можливо Вас цікавить?", "human": [11.1, 11.2, 11.3, 11.4, 11.5, 11.6, 11.7, 11.8, 6] },
     




      },
      "human": {
        "0": { "content": "Привіт! Я радий з тобою<br> познайомитись", "bot": 1 },
        #"1": { "content": "Салют!", "bot": 2 },
        # "2": { "content": "Привіт, Бот!", "bot": 2 },
        "3": { "content": "", "bot": 3, "name": "name" },
        "4": { "content": "Центр надання адміністративних <br/> послуг", "bot": 4 },
        "4.1": {"content": "Як записатись на прийом в ЦНАП?", "bot": 4.1 },
        "4.2": {"content": "Які послуги надає ЦНАП?", "bot": 4.2 },
        "4.3": {"content": "Графік прийому у ЦНАП?", "bot": 4.3 },
        "4.4": {"content": "Де можна ознайомитись/отримати  <br/> заяви  та перелік документів  <br/> для адміністративних послуг?", "bot": 4.4 },
        "4.5": {"content": "Які послуги можна отримати  <br/> не приходячи в ЦНАП?", "bot": 4.5 },
        "4.6": {"content": "Як отримати консультацію <br/> щодо роботи ЦНАП?", "bot": 4.6 },
        "4.7": {"content": "Як перевірити стан виконання <br/> адміністративної послуги?", "bot": 4.7 },
        "5": {  },
        "6": { "content": "На початок ", "bot": 3 },
        "7": {"content": "Депутати міської ради", "bot": 7 },
        "7.1": {"content": "<a href=\"https://rada-uzhgorod.gov.ua/miska_rada#vvhap6fxmz\" target=\"_blank\">Депутатський корпус</a>" },
        "7.2": {"content": "<a href=\"https://rada-uzhgorod.gov.ua/category/grafiky-provedennya-komisij\" target=\"_blank\">Графіки проведення комісій</a>" },
        "7.3": {"content": "<a href=\"https://rada-uzhgorod.gov.ua/rada_docs/plany-provedennia-sesii\" target=\"_blank\">Плани проведення сесії</a>" },
        "8": {"content": "Міжнародне співробітництво", "bot": 8 },
        "8.1": {"content": "Міста побратими", "bot": 8.1 },
        "8.2": {"content": "Перелік та стан реалізації <br/> грантових проєктів", "bot": 8.2 },
        "9": {"content": "Держархбудконтроль", "bot": 9 },
        "9.1": {"content": "Де знайти бланк повідомлення <br/> про початок виконання <br/> будівельних робіт?", "bot": 9.1 },
        "9.2": {"content": "Де знайти бланк декларації <br/> про готовність до експлуатації <br/> об’єкта", "bot": 9.2 },
        "9.3": {"content": "Які документи подаються <br/> крім декларації про готовність <br/> до експлуатації по амністії?", "bot": 9.3 },
        "9.4": {"content": "Якщо в документах виявлено <br/> технічну помилку, <br/> як можна виправити?", "bot": 9.4 },
        "9.5": {"content": "Як дізнатись коду об’єкта <br/> для заповнення дозвільного <br/> документу?", "bot": 9.5 },
        "9.6": {"content": "Яким чиином <br/> можна подати документи?", "bot": 9.6 },
        "9.7": {"content": "Будинок побудований без <br/> дозвільних документів <br/> в період 1992-2015 р.р., <br/>  як можна здати в  експлуатацію?", "bot": 9.7 },
        "9.8": {"content": "Чи доступна інформація <br/> зі старого реєстру ДАБІ", "bot": 9.8 },
        "9.9": {"content": "Як заповнювати документ <br/> у випадку,коли наявні <br/> два замовника будівництва?", "bot": 9.9 },
        "9.10": {"content": "Який документ необхідно <br/> зазначати в інформації <br/> про земельну ділянку?", "bot": 9.10 },
        "9.11": {"content": "Яким чином можна подати заяву <br/> на отримання дозволу <br/> про початок виконання <br/> будівельних робіт?", "bot": 9.11 },
        "9.12": {"content": "Яким чином отримати сертифікат  <br/> про готовність до експлуатації?", "bot": 9.12 },
        "9.13": {"content": "Де можна дізнатись <br/> реєстраційний номер документа?", "bot": 9.13 },
        "9.14": {"content": "Де можна ознайомитись  <br/> з графіком планових перевірок <br/> ДАБК УМР?", "bot": 9.14 },
        "9.15": {"content": "Де можна сплатити <br/> штрафну санкцію, <br/> згідно з постановою про  <br/> накладення штрафу за порушення <br/> вимог законодавства, винесену <br/> ДАБК УМР?", "bot": 9.15 },
        "9.16": {"content": "Який термін сплати постанови <br/> про накладення штрафу <br/>  за порушення вимог законодавства <br/> винесену ДАБК УМР?", "bot": 9.16 },
        "9.17": {"content": "Яка адміністративна відповідальність  <br/> передбачена  за здійснення <br/> самовільного будівництва?", "bot": 9.17 },
        "10": {"content": "Департамент міської інфраструктури", "bot": 10 },
        "10.1": {"content": "Чи можна передати в оренду <br/> об’єкт  без включення  <br/> до переліку 1 чи 2 типу?", "bot": 10.1 },
        "10.2": {"content": "Який механізм реалізації переважного <br/> права чинного орендаря на продовження договору <br/> оренди державного та комунального майна? ", "bot": 10.2 },
        "10.3": {"content": "Чи обмежена кількість окремих, <br/> ізольованих приміщень, які балансоутримувач <br/> (державна установа) має право здавати в оренду <br/>
                самостійно, зважаючи на загальну площу, <br/> визначену другою частиною <br/>  статті4 Закону України <br/> «Про оренду державного <br/> та комунального майна»? ", "bot": 10.3 },
        "10.4": {"content": "Чи може фізична особа <br/> виступати потенційним орендарем? ", "bot": 10.4 },
        "11": {"content": "Допомога ВПО ", "bot": 11.1 },
        "11.1": {"content": "<a href=\"https://groshi.edopomoga.gov.ua/#status\" target=\"_blank\">Як отримати статус ВПО </a>", "bot": 11.1 },
        "11.2": {"content": "<a href=\"https://groshi.edopomoga.gov.ua/#vpo-pay\" target=\"_blank\">Як отримати виплати для ВПО </a>", "bot": 11.3 },
        "11.3": {"content": "<a href=\"https://groshi.edopomoga.gov.ua/#damaged \" target=\"_blank\">Повідомлення про <br/>пошкоджене майно </a>", "bot": 11.2 },
        "11.4": {"content": "<a href=\"https://groshi.edopomoga.gov.ua/#business\" target=\"_blank\">Компенсація підприємцю за <br/>працевлаштування ВПО </a>", "bot": 11.4 },
        "11.5": {"content": "<a href=\"https://groshi.edopomoga.gov.ua/#liberated\" target=\"_blank\">Допомога жителям нещодавно<br/> звільнених територій і тим, <br/>хто поїхав </a>", "bot": 11.5 },
        "11.6": {"content": "<a href=\"https://groshi.edopomoga.gov.ua/#occupied\" target=\"_blank\">Українцям, які проживають на <br/>тимчасово окупованих територіях </a>", "bot": 11.6 },
        "11.7": {"content": "<a href=\"https://groshi.edopomoga.gov.ua/#subsidy\" target=\"_blank\">Як отримати пенсію чи субсидію<br/>на банківську карту </a>", "bot": 11.7 },
        "11.8": {"content": "<a href=\"https://www.youtube.com/watch?v=b6eyFNdg28s&ab_channel=%D0%94%D1%96%D1%8F\" target=\"_blank\">Відеоінструкція від порталу -ДІЯ-</a>", "bot": 11.8 },

        
       




      },
    }
  end
end