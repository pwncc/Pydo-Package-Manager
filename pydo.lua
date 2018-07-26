local debounce = true
local repoFiles = fs.list("/pydo/repos/")
local repos = {}
local repolist = fs.open("/pydo/repos/repolist", "r")
local tArgs = {...}

--check update
pydo = fs.open("pydo.lua", "r")
readall = pydo.readAll()
pydo.close()
lib1 = fs.open("libs/puplib", "r")
readall2 = lib1.readAll()
lib1.close()

--delete installer file if still there
if fs.exists("installer") then
fs.delete("installer")
end


if _G.checkupdated == nil then
print("Checking for updates..")
if readall == http.get("https://raw.githubusercontent.com/pwncc/Pydo-Package-Manager/master/pydo.lua").readAll() then
if readall2 == http.get("https://raw.githubusercontent.com/pwncc/Pydo-Package-Manager/master/libs/puplib.lua").readAll() then
print("Pydo is up to date!")
_G.checkupdated = 1
else
_G.checkupdated = 1
printError("puplib is not up to date! please run pydo update! You can continue if you want")
end
else
_G.checkupdated = 1
printError("Pydo itself has an update! Please use pydo update! You can continue without updating")
end
else
end



if fs.exists("libs/puplib") then
library1 = fs.open("libs/puplib", "r")
pup = loadstring(library1.readAll())()
library1.close()
else
printError("Puplib could not be found! Please run pydo.lua update!")
end

local function printhelp()
  print("Following functions")
  print(" ")
  print("help --prints help")
  print("install (reponame) (packagename) --installs a package from the repo given")
  print("installfile (file) --installs a package from file")
  print("list (reponame) --for a list of packages in that repo")
  print("uninstall (packagename) --to uninstall a package")
  print("installed --to view installed packages")
  print("update --updates pydo")
  print("repolist --shows all repo's")
  print("download (reponame) (packagename)")
  print("info (reponame OR 'file') (packagename OR filename)")
end
loadstring(repolist.readAll())()
if tArgs[1] == "repolist" then
print(textutils.serialize(repotable))	
elseif tArgs[1] == "help" then
  printhelp()
elseif tArgs[1] == "info" then
if tArgs[2] == "file" then
if fs.exists(tArgs[3]) then
print("Checking file..")
metatable = pup.getMeta(tArgs[3])
sleep(1)
print("info:")
print(metatable["info"])
print(" ")
print("dependencies:")
print(" ")
print(metatable["dependencies"])
else
printError("File doesnt exist!")
end
else
if tArgs[3] then
local site = http.get(repotable[tArgs[2]].."files/"..tArgs[3])
		print(site)
			if site then
			print("Connected to repo")
			local file = site.readAll()
				if file then
				temporary = fs.open(".temporary", "w")
				temporary.write(file)
				temporary.close()
				print("Grabbed file..")
				sleep(1)
				print("Checking file..")
				metatable = pup.getMeta(".temporary")
				print("info:")
				print(metatable["info"])
				print(" ")
				print("dependencies:")
				print(" ")
				print(metatable["dependencies"])
				else
				error("The file contains nothing! Or was never fetched!")
			end
		end
else
printError("Invalid Input! Use pydo.lua info (reponame) (packagename)")
end
end

elseif tArgs[1] == "update" then
	fs.delete("pydo.lua")
	fs.delete("libs/puplib")
	shell.run("wget https://raw.githubusercontent.com/pwncc/Pydo-Package-Manager/master/pydo.lua pydo.lua")
	print("Installing libraries..")
	shell.run("wget https://raw.githubusercontent.com/pwncc/Pydo-Package-Manager/master/libs/puplib.lua /libs/puplib")
elseif tArgs[1] == "installed" then
	local packagelist = fs.list("/.installed/")
		for _, file in ipairs(packagelist) do
		sleep(0.5)
		print(file)
end
elseif tArgs[1] == nil then
printhelp()
elseif tArgs[1] == "uninstall" then
	if fs.exists("/.installed/"..tArgs[2]) then
		print("Uninstalling")
		pup.uninstall("/.installed/"..tArgs[2], "/")
		shell.run("delete /.installed/"..tArgs[2])
	else
		error("Package does not exist!")
	end
elseif tArgs[1] == "installfile" then
	if fs.exists(tArgs[2]) then
		shell.run("copy tArgs[2] /.installed/")
		print("Installing..")
		pup.unpack(tArgs[2], "/")
		print("Done..!")
		print("Checking for installer file..")
			if fs.exists("installer") then
			print("Found.. Running...")
			sleep(1)
			shell.run("installer")
			sleep(3)
			print("Deleting installer..")
			fs.delete("/installer")
			sleep(1)
			print("Done!")
		else
			print("Is not there. Most likely not required!")
		end
	else
print("File does not exist!")
end
elseif tArgs[1] == "download" then
if tArgs[2] then
		if tArgs[3] then
  local site = http.get(repotable[tArgs[2]].."files/"..tArgs[3])
		print(site)
			if site then
			print("Connected to repo")
			local file = site.readAll()
				if file then
				temporary = fs.open(".temporary", "w")
				temporary.write(file)
				temporary.close()
				print("Grabbed file..")
				sleep(1)
				shell.run("copy .temporary /pydo/downloads/"..tArgs[3]..".pyd")
				sleep(1)
				print("...Done! The file is downloaded in /pydo/downloads/ !")
				else
				error("The file contains nothing! Or was never fetched!")
			end
		end
		else
		error("I was not able to fetch the file! Did you spell it correctly?")
	end
end
elseif tArgs[1] == "install"  then
	if tArgs[2] then
		if tArgs[3] then
  local site = http.get(repotable[tArgs[2]].."files/"..tArgs[3])
		print(site)
			if site then
			print("Connected to repo")
			local file = site.readAll()
				if file then
				temporary = fs.open(".temporary", "w")
				temporary.write(file)
				temporary.close()
				print("Grabbed file..")
				sleep(1)
				shell.run("copy .temporary /.installed/"..tArgs[3])
				pup.unpack(".temporary", "/")
				print("Installing..")
				sleep(1)
				print("...Done!")
				print("Checking for installer file..")
				if fs.exists("installer") then
				print("Found.. Running...")
				sleep(1)
				shell.run("installer")
				sleep(3)
				print("Deleting installer..")
				fs.delete("/installer")
				sleep(1)
				print("Done!")
				else
				print("Is not there. Most likely not required!")
				end
				else
				error("The file contains nothing! Or was never fetched!")
			end
		end
		else
		error("I was not able to fetch the file! Did you spell it correctly?")
	end
end
else
  if tArgs[1] == "list" then
    if tArgs[2] then
      sitelist = print(http.get(repotable[tArgs[2]].."list").readAll())
      print(repotable[tArgs[2]])
      print(sitelist)
      else
      print("Invalid input!")
    end
  end
end
