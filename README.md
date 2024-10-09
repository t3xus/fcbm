
# **FCBM - Riskware PowerShell Removal Tool**  
![Static Badge](https://img.shields.io/badge/Author-Jgooch-1F4D37)
![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
![Static Badge](https://img.shields.io/badge/Distribution-npm-orange)
![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Target](https://img.shields.io/badge/Target-Microsoft%20Windows%2011%20Professional-357EC7)

## **Overview**

**FCBM** is a command-line tool designed to detect, remove, and block variants of **Riskware.PowerShell** and **SP.Generic** on Windows systems. It efficiently manages processes and system tasks that could pose a risk, providing enhanced security for your machine.

This tool is particularly useful for administrators needing a fast way to handle system-level threats or potential task management risks.  

---

## **Features**
- **Automatic Detection and Removal:** Identifies and terminates suspicious tasks or processes.
- **Take Ownership Capability:** Adds a "Take Ownership" context menu option to make system file management easier.
- **Task Deletion:** Deletes scheduled tasks from the system to ensure malicious tasks are removed.
- **Security Enhancements:** Sets appropriate permissions and attributes for system directories, preventing unauthorized changes.
- **Easy-to-Use Flags:** Includes options for verbose output, help, and version information.

---

## **Usage**

To run **FCBM**, simply execute it in the Windows command prompt with appropriate flags or arguments. Below is a list of usage options:

```bash
fcbm [flags] "required argument" "optional argument"
```

### **Flags:**
| Flag              | Description                           |
|-------------------|---------------------------------------|
| `/?, --help`      | Displays help information             |
| `/v, --version`   | Displays the version of the tool      |
| `/e, --verbose`   | Enables detailed output               |
| `-f, --flag value`| Specifies a named parameter value     |

---

## **Installation**

1. Clone the repository or download the script:
   ```bash
   git clone https://github.com/t3xus/fcbm.git
   ```

2. Navigate to the directory where the script is saved.

3. Run the script with administrator privileges to ensure it can modify system files.

---

## **How It Works**

1. **Dependency Check**: The script ensures Homebrew (for macOS) or other package managers are installed if necessary. It checks for essential dependencies such as `curl`, `xmlstarlet`, and `timg`, installing them if they're missing.

2. **Process Management**: The script will scan running tasks and processes, terminating known unwanted processes that could be associated with malware or riskware.

3. **Take Ownership**: It adds a **Take Ownership** context menu option for files and directories, making it easier to manage permissions and modify protected files.

4. **Task Cleanup**: Deletes unnecessary or risky scheduled tasks to prevent future exploitation.

---

## **License**

This project is licensed under the MIT License - see the [LICENSE](https://github.com/t3xus/fcbm/blob/main/LICENSE) file for details.

**Copyright 2022** James Gooch

---

## **Disclaimer**

**THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND**, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT, OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

---

### **Version**

**FCBM** v1.0.0

---
