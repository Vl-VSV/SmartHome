from aiogram import Bot, Dispatcher, executor, types
import config
import requests

bot = Bot(token=config.token)
dp = Dispatcher(bot)

MAIN_URL = 'https://smarthome-dm1x.onrender.com'


@dp.message_handler(commands=['start'])
async def send_welcome(message: types.Message):
    await message.reply("Hello! I am SmartHome bot by VSV\nI can control the LEDs")


@dp.message_handler(commands=['ledOn'])
async def led_on(message: types.Message):
    requests.get(f'{MAIN_URL}/setLed?state=1')
    await message.reply("The LED was Turned On successfully")


@dp.message_handler(commands=['ledOff'])
async def led_off(message: types.Message):
    requests.get(f'{MAIN_URL}/setLed?state=0')
    await message.reply("The LED was Turned Off successfully")


@dp.message_handler(commands=['getTemp'])
async def led_off(message: types.Message):
    r = requests.get(f'{MAIN_URL}/getData')
    temp = r.json()['temperature']
    await message.reply("The Temperature: " + str(temp) + "Cº")


@dp.message_handler(commands=['setRGB'])
async def rgb_control(message: types.Message):
    rgb = list(map(int, message.text[8:].split()))
    rgb = [x if 0 <= x <= 255 else 0 for x in rgb]
    requests.get(f'{MAIN_URL}/setRGB?r={rgb[0]}&g={rgb[1]}&b={rgb[2]}')
    await message.reply(f'The RGB LED was changed successfully\nr = {rgb[0]}\ng = {rgb[1]}\nb = {rgb[2]}')


@dp.message_handler(commands=['help'])
async def helps(message: types.Message):
    help_text = "Available commands:\n"
    help_text += "/start - Start\n"
    help_text += "/help - List of commands\n"
    help_text += "/ledOn - Turn On the LED\n"
    help_text += "/ledOff - Turn Off the LED\n"
    help_text += "/setRGB - Change RGB LED Color\n"
    help_text += "/getTemp - Get Temperature\n"
    await message.reply(help_text)


if __name__ == '__main__':
    executor.start_polling(dp, skip_updates=True)
