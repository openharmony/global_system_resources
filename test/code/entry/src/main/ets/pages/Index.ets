/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

export interface ModeType {
  id: number
  name: string
  fontText: string
}

// 单个选择项的渲染
@Component
struct ModeItem {
  private mode: ModeType = { id: 0, name: '', fontText: '' }
  @Consume modeId: number

  @Builder
  renderModeItem(fontColor: string, bgColor: string, value: string) {
    Flex({ direction: FlexDirection.Column }) {
      Flex() {
        Text(value)
          .fontSize(16)
          .fontColor(fontColor)
      }
      .height('100%')
      .width('100%')
      .backgroundColor(bgColor)
      .borderRadius(12)
      .padding({
        left: 14,
        top: 14,
        bottom: 14
      })

      // 最后一项不显示分隔线
      if (this.mode.id != 5) {
        Flex() {
          Flex() {
          }.height(1).width('100%').backgroundColor('#F3F3F3')
        }
        .padding({
          left: 12,
          right: 12
        })
      }
    }
  }

  build() {
    Flex() {
      // 选中项和其他选项的样式有不同
      if (this.modeId == this.mode.id) {
        this.renderModeItem('#0A59F7', '#E6EEFF', this.mode.name)
      } else {
        this.renderModeItem('rgba(0,0,0,0.9)', '', this.mode.name)
      }
    }.height(48)
  }
}

@Entry
@Component
struct ScrollerList {
  private scroller: Scroller = new Scroller(); // 创建一个滚动控制器
  @Provide modesData: ModeType[] = [
    {
      id: 1,
      name: 'und-Ethi',
      fontText: "ዝናብ በዛፎችና በሸለቆ ላይ ይወርዳል፤ ዝርዝናው ገልጦ ይታያል፥ የቀድሞው ሙዚቃ"
    },
    {
      id: 2,
      name: 'und-Hebr',
      fontText: "הגשם נופל על העצים והקרקעים, הקצב ברור ונחמד להקשיב, המוזיקה העתיקה"
    },
    {
      id: 3,
      name: 'und-Thai',
      fontText: "ฝนที่ตกลงมากระทบต้นไม้และกระเบื้อง ทำนองคมชัดน่าฟัง,เพลงโบราณนั้น"
    },
    {
      id: 4,
      name: 'und-Armn',
      fontText: "Անձրևը ընկնում է ծառերի և կտորների վրա, ռիթմը պարզ է և հաճելի է լսել, հին երաժշտությունը"
    },
    { id: 5,
      name: 'und-Geor',
      fontText: "დიყვანი გადასრულია ეხელებზე და ტვილზე, რიტიმა წესია და საკმაოდ სურს, ედინარე მუსიკა"
    },
    {
      id: 6,
      name: 'und-Deva',
      fontText: "प्राचीन संगीत स्पष्ट और सुनने के लिये वृक्षों और टायलों पर बरसाता है,  वृक्षं वृक्षस्थितिः स्पष्टं चिदन्तुम् । प्राचीन सङ्गीतम् ।"
    },
    {
      id: 7,
      name: 'und-Gujr',
      fontText: "વૃક્ષો અને ટાઈલો પર વરસાદ પડે છે, રીથ્મ સ્પષ્ટ અને આનંદિત છે, પ્રાચીન સંગીત"
    },
    {
      id: 8,
      name: 'und-Guru',
      fontText: 'ਮੀਂਸ਼ਹਿਰ ਵਾਰਾਂ ਅਤੇ ਟਾਈਲਾਂ ਉੱਤੇ ਹੁੰਦਾ ਹੈ, ਰੀਥਮ ਸਾਫ਼ ਅਤੇ ਪਹਿਲਾਂ ਸੁਨਾਉਣ ਲਈ ਪਹਿਲਾਂ ਸੰਗੀਤ'
    },
    {
      id: 9,
      name: 'und-Taml',
      fontText: "மழை மரங்கள் மற்றும் இலைகள் மீது விழுகிறது, நல்ல உணர்கிறது"
    },
    {
      id: 10,
      name: 'und-Mlym',
      fontText: "മഴ വൃക്ഷങ്ങളില്‍ വീഴുന്നു, പഴയ സംഗീതം കേള്‍ക്കുന്നത് കേള്‍ക്കുന്നു"
    },
    {
      id: 11,
      name: 'und-Beng',
      fontText: "বৃষ্টি গাছগুলো এবং শস্যের উপর পড়ে যায়, গাছগুলো পরিষ্কার এবং শোনার জন্য সুন্দর এবং প্রাচীন সঙ্গীত"
    },
    {
      id: 12,
      name: 'und-Telu',
      fontText: "వృక్షములమీద వర్షము కురిచిపోవుచున్నది పూర్వ సంగీతము వినుటకు స్పష్టముగా సంతోషముగా ఉన్నది"
    },
    {
      id: 13,
      name: 'und-Knda',
      fontText: "ಮರಗಳ ಮೇಲೆ ಮಳೆಯು ಬೀಳುತ್ತದೆ; ರೀತ್ಮವು ಕೇಳುವದಕ್ಕೆ ಸ್ಪಷ್ಟವಾಗಿಯೂ ರಮ್ಯವಾಗಿಯೂ ಪೂರ್ವಕಾಲ ಸಂಗೀತ"
    },
    {
      id: 14,
      name: 'und-Orya',
      fontText: "ବୃକ୍ଷ ଏବଂ ଟାଇଲଗୁଡ଼ିକରେ ବର୍ଷା ଭାରିଥାଏ, ଏହି ସଙ୍ଗୀତ ସ୍ପଷ୍ଟ ଓ ସୁନିଶ୍ଚିତ ହୋଇଥାଏ, ପୁରାତନ ସଂଗୀତ"
    },
    {
      id: 15,
      name: 'und-Sinh',
      fontText: "වස්තුවක් ගස් වලින් තියෙනවා, රිත්මය පැහැදිලි සහ සතුටුයි, පරණ සංගීතය අහන්න,"
    },
    {
      id: 16,
      name: 'und-Khmr',
      fontText: "ភ្លៀង​ធ្លាក់​លើ​មែកធាង និង​ក្រឡាក្បឿង​ស្អាត និង​ស្អាត"
    },
    {
      id: 17,
      name: 'und-Laoo',
      fontText: "ຫົວໄປ ຕ່າງໆແລະຈາມ, ການຕົວໄປ ຖືກຕ້ອງ ແລະ ຍົກເລືອລີ, ອົດສະຕິກລະດູຮ້ອງໄດ້ພໍານົດ."
    },
    {
      id: 18,
      name: 'und-Mymr',
      fontText: "မိုဃ်းရွာသည် သစ်ပင်နှင့် ကျောက်ပင်တို့အပေါ်မှာ လဲလျက်ရှိ၏။ သီချင်းဆိုသည် ရှင်းလင်းပြီး နားထောင်ခြင်းငှါ၊ ရ"
    },
    {
      id: 19,
      name: 'ja',
      fontText: "雨が木や瓦に当たって、リズムが澄んでいて、その古い音楽"

    },
    { id: 20,
      name: 'ko',
      fontText: "비가 나무와 기와를 때리니, 운율이 모두 맑고 낭랑하여, 그 오래된 음악은"
    }
  ]
  @Provide modeId: number = 0 // 当前选中项id
  @Provide lang: string = ''
  @Provide langName: string = ''

  build() {
    Column() {
      Search()
        .searchButton('搜索测试语言')
        .height(30)
        .width('100%')
        .onSubmit((value: string) => {
          this.langName = value
          for (let index = 0; index < this.modesData.length; index++) {
            if (value == this.modesData[index].name) {
              this.lang = this.modesData[index].fontText
              break
            }
          }
        })
      Text('选择测试语言')
        .height(30)
        .width('100%')
      Scroll(this.scroller) { // 绑定滚动控制器
        Column() {
          // 循环产生下拉菜单
          ForEach(this.modesData, (item: ModeType) => {
            Flex() {
              ModeItem({ mode: item })
            }
            // 为每一项绑定点击事件
            .onClick(() => {
              if (this.modeId !== item.id) {
                this.modeId = item.id
              }
              this.langName = item.name
              this.lang = item.fontText
            })

          }, (item: ModeType) => item.id.toString())
        }
        .width("100%")
      }
      .scrollable(ScrollDirection.Vertical) // 设置竖直方向滚动
      .scrollBarColor(Color.Green) // 设置滚动条颜色
      .scrollBarWidth(20) // 设置滚动条宽度
      .scrollBar(BarState.On) // 设置滚动条永久显示
      .width('100%')
      .height(220)
      .padding({ top: 10, bottom: 10 })
      .backgroundColor(Color.Pink)
      .width('100%')
      .margin({ top: 10 })

      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Scroll() {
          Column() {
            Text(this.langName)
              .fontSize(30)
              .fontColor('red')
            Text(this.lang)
              .fontSize(30)
          }
        }
        .position({ x: 0, y: 50 })
        .scrollable(ScrollDirection.Vertical) // 设置竖直方向滚动
        .width('100%')
      }.height('40%').width('100%').backgroundColor('#fff').borderRadius(16)
    }
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height(('100%'))
    .padding(20)
  }
}
