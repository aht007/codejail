import codejail.jail_code
codejail.jail_code.configure('python', '<SANDENV>/bin/python')
import codejail.safe_exec
codejail.safe_exec.safe_exec("import os\nos.system('ls /etc')", {})
