import discord
from discord.ext import commands
import config
import requests

BASE_URL = 'https://smarthome-dm1x.onrender.com'

intents = discord.Intents.default()
intents.message_content = True
bot = commands.Bot(command_prefix=config.prefix, intents=intents)


class LedControl(commands.Cog):
    """Using to control the LED"""

    @commands.command()
    async def ledOn(self, ctx):
        """Turn on the LED"""
        requests.get(f"{BASE_URL}/setLed?state=1")
        await ctx.send(f'The LED was turned on successfully')

    @commands.command()
    async def ledOff(self, ctx):
        """Turn off the LED"""
        requests.get(f"{BASE_URL}/setLed?state=0")
        await ctx.send(f'The LED was turned off successfully')


class TemperatureControl(commands.Cog):
    """Using ot control the Temperature"""

    @commands.command()
    async def getTemp(self, ctx):
        """Get Temperature"""
        r = requests.get(f"{BASE_URL}/getData")
        temp = r.json()["temperature"]
        await ctx.send(f'Temperature: ' + str(temp) + "º")


@bot.event
async def on_ready():
    await bot.add_cog(LedControl())
    await bot.add_cog(TemperatureControl())


bot.run(config.token)
