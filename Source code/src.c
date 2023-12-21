#include <mega16.h>
#include <alcd.h>
#include <delay.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

#define EEPROM_READY !(EECR & (1 << EEWE))
#define EEPROM_WAIT while (!EEPROM_READY)
#define DELIMITER 0xFF

void userEnter();
int checkUserID(const char ID[3]);
bool checkPassCode(const char PC[3], int address);
void AdminEdit();
void UserEdit();
void getName(int address);
void storeNewPC(const char newPC[3], int address);
void rawData();
void readData();
unsigned char EE_Read(unsigned int address);
void EE_Write(unsigned int address, unsigned char data);
void motor();
void Buzz();
char keypad();

void main(void)
{
    //LCD
    DDRC = 0b00000111;
    PORTC = 0b11111000;
    lcd_init(16);

    //Push-Down button Interrupt
    DDRD.2 = 0;
    DDRD.3 = 0;
    PORTD.2 = 1;
    PORTD.3 = 1;

    //SOUNDER
    DDRD.5 = 1;

    //Interrupt
    GICR |= (1 << INT0);                 // Enable INT0
    GICR |= (1 << INT1);                // Enable INT1

    MCUCR |= (1 << ISC01) | (1 << ISC00); // Trigger INT0 on rising edge
    MCUCR |= (1 << ISC11) | (1 << ISC10); // Trigger INT1 on rising edge

    SREG.7 = 1; // Enable global interrupts  
    
    
    //Motor
    DDRD.0 = 1;
    DDRD.1 = 1;

    rawData(); // Call rawData once to store data in EEPROM

    while (1)
    {
    char number = keypad();
    lcd_clear();

    if (number == '*')
        { 
        userEnter();
        }
    }
}

void userEnter()
{
    char ID[3];
    char PC[3];
    int IdAddres;
    bool pcCode;
    int i;

    lcd_clear();
    lcd_printf("Enter your ID : ");
    for (i = 0; i < 3; i++)
        {
        ID[i] = keypad();
        lcd_putchar(ID[i]);
        }

    // Check EEPROM for ID
    IdAddres = checkUserID(ID);
    if (IdAddres)
        {
        lcd_clear();
        lcd_printf("Enter Your PC : ");

        for (i = 0; i < 3; i++)
            {
            PC[i] = keypad();
            lcd_putchar(PC[i]);
            }
        pcCode = checkPassCode(PC, IdAddres);
        if(!pcCode)
            {
            lcd_clear();
            lcd_printf("Sorry Wrong PC");   //1 peep
            Buzz();
            }
        else
            {
            lcd_clear();
            getName(IdAddres);
            motor();
            }
        }
    else{ 
        lcd_clear();
        lcd_printf("Wrong ID");    // 2 peep 
        Buzz();
        Buzz();
        }

}

int checkUserID(const char ID[3]){
    int eeprom_address = 6; 
    char eeprom_ID;
    int found = 0;
    int i;
    int j;
    for (i = 0; i < 3; i++)
        {
        eeprom_address = 6 + i * 14; 
        for (j = 0; j < 3; j++)
            {
            EEPROM_WAIT;  // Wait till EEPROM is ready
            eeprom_ID = EE_Read(eeprom_address) + '0';
            delay_ms(500);
            if (eeprom_ID == ID[j])    
                {
                found += 1; // Increment the count when a match is found
                }
            eeprom_address++;
            }
        if (found == 3)
            return eeprom_address + 1 ; else
            {
            found = 0; // Reset the count for the next iteration
            }
        }
    return false;
}

bool checkPassCode(const char PC[3], int address){
    char eeprom_PC;
    int i;

    for (i = 0; i < 3; i++)
        {
        EEPROM_WAIT;  // Wait till EEPROM is ready
        eeprom_PC = EE_Read(address) + '0';  // Convert digit to character
        if (eeprom_PC != PC[i])
            {
            return false; // PC does not match, return false
            }
        address++;
        }

    return true; // PC matches, return true
}

void getName(int address){
    int i;    
    char name;
    address = address-10;
    lcd_printf("Welcome, ");
    for( i=0; i<5 ;i++)
    {
        name = EE_Read(address);
        lcd_printf("%c",name);
        address++;
    }
}

void AdminEdit()
{
 char userID[3];
  char newUserPC[3]; 
  char confirmPC[3];
  int userIdAddres;
  int i;

  lcd_clear();
  lcd_printf("Enter user ID: ");

  for (i = 0; i < 3; i++) {
    userID[i] = keypad();
    lcd_putchar(userID[i]);
  }

  userIdAddres = checkUserID(userID);

  if (userIdAddres) {
    lcd_clear();
    lcd_printf("Enter new PC: ");  
    
      for (i = 0; i < 3; i++) {
        newUserPC[i] = keypad();
        lcd_putchar(newUserPC[i]);
      }
             
      lcd_clear();
      lcd_printf("Renter new PC: ");  

      for (i=0;i<3;i++)
      {
         confirmPC[i] = keypad();
         lcd_putchar(newUserPC[i]);
      }  
      
      for (i=0;i<3;i++)
      {
        if(confirmPC[i] != newUserPC[i])
        {
            lcd_clear();
            lcd_printf("Contact Admin");
            Buzz();
            Buzz(); 
            return;
        }
      }
     lcd_clear();
     lcd_printf("New PassCode saved");
     delay_ms(100); 
     storeNewPC( newUserPC,userIdAddres);
     
  } else {
    lcd_clear();
    lcd_printf("Contact Admin");
    delay_ms(100);   
     Buzz();
     Buzz();
  }

  lcd_clear(); // Clear the LCD after the loop

}

void UserEdit() {
  char userID[3];
  char newUserPC[3]; 
  char confirmPC[3];
  int userIdAddres;
  int i;

  lcd_clear();
  lcd_printf("Enter user ID: ");

  for (i = 0; i < 3; i++) {
    userID[i] = keypad();
    lcd_putchar(userID[i]);
  }
  
  userIdAddres = checkUserID(userID);

  if (userIdAddres) {
    lcd_clear();
  lcd_printf("Enter user PC: ");

  for (i = 0; i < 3; i++) {
    newUserPC[i] = keypad();
    lcd_putchar(newUserPC[i]);
  }
  if(!(checkPassCode(newUserPC , userIdAddres)))
     {
          lcd_clear();
          lcd_printf("Contact Admin");
          Buzz();
          Buzz();  
          return;
     }   
     lcd_clear();
    lcd_printf("Enter new PC: ");  
    
      for (i = 0; i < 3; i++) {
        newUserPC[i] = keypad();
        lcd_putchar(newUserPC[i]);
      }
             
      lcd_clear();
      lcd_printf("Renter new PC: ");  

      for (i=0;i<3;i++)
      {
         confirmPC[i] = keypad();
         lcd_putchar(confirmPC[i]);
      }  
      
      for (i=0;i<3;i++)
      {
        if(confirmPC[i] != newUserPC[i])
        {
            lcd_clear();
            lcd_printf("Contact Admin");
            Buzz();
            Buzz(); 
            return;
        }
      }
     lcd_clear();
     lcd_printf("New PassCode saved");
     delay_ms(100); 
     storeNewPC( newUserPC,userIdAddres);
     
  } else {
    lcd_clear();
    lcd_printf("Contact Admin");
    delay_ms(100);
     Buzz();
     Buzz(); 
  }


  lcd_clear(); // Clear the LCD after the loop
}

void storeNewPC(const char newPC[3], int address){
    int eeprom_address = address;
    int i;
    int digit;

    for (i = 0; i < 3; i++)
        {
        EEPROM_WAIT;  // Wait till EEPROM is ready
        delay_ms(500);

        // Convert character to integer
        digit = newPC[i] - '0';

        // Print debugging information
        lcd_clear();
        //lcd_printf("Writing %d to %d", digit, eeprom_address);
        //delay_ms(1000);

        EE_Write(eeprom_address, digit);
        eeprom_address++;
        }
}

void rawData()
{
    char user_names[][6] = {"Alice", "Robrt", "Charl"};
    short user_ids[] = {111, 503, 504};
    short user_passwords[] = {564, 923, 546};
    int userIndex;
    int i;
    int eeprom_address = 0; // Starting EEPROM address for sequential reading

    for (userIndex = 0; userIndex < sizeof(user_ids) / sizeof(user_ids[0]); userIndex++)
        {
        // Write User Name to EEPROM (fixed length)
        for (i = 0; i < 5; ++i)
            {
            EE_Write(eeprom_address, user_names[userIndex][i]);
            eeprom_address++;
            }

        // Delimiter between user name and ID
        EE_Write(eeprom_address, DELIMITER);
        eeprom_address++;

        // Write User ID (3 digits) to EEPROM
        EE_Write(eeprom_address, user_ids[userIndex] / 100);
        EE_Write(eeprom_address + 1, (user_ids[userIndex] / 10) % 10);
        EE_Write(eeprom_address + 2, user_ids[userIndex] % 10);
        eeprom_address += 3; // Move to the next address for the next data

        // Delimiter between user id and password
        EE_Write(eeprom_address, DELIMITER);
        eeprom_address++;

        // Write User Password (3 digits) to EEPROM
        EE_Write(eeprom_address, user_passwords[userIndex] / 100);
        EE_Write(eeprom_address + 1, (user_passwords[userIndex] / 10) % 10);
        EE_Write(eeprom_address + 2, user_passwords[userIndex] % 10);
        eeprom_address += 3; // Move to the next address for the next data

        // Delimiter between different users
        EE_Write(eeprom_address, DELIMITER);
        eeprom_address++;
        }

    // Mark the end of data with 0xFFFF
    EE_Write(eeprom_address, 0xFF);
    EE_Write(eeprom_address + 1, 0xFF);
    EE_Write(eeprom_address + 2, 0xFF);
}

void readData()
{
    int eeprom_address = 0; // Starting EEPROM address for sequential reading
    int i;
    for(i = 0; i < 3; i++)
        {
        int i = 0;               // Reset i for each user
        char user_name[6];       // Fixed size for user names
        int user_id;
        int user_password;

        // Read User Name from EEPROM (fixed length)
        for (i = 0; i < 5; ++i)
            {
            user_name[i] = EE_Read(eeprom_address);
            eeprom_address++;
            }
        user_name[5] = '\0'; // Null-terminate the string

        // Check and skip delimiter between user name and ID
        if (EE_Read(eeprom_address) != DELIMITER)
            {
            // Handle delimiter error or end of data
            break;
            }
        eeprom_address++;

        // Read User ID (3 digits) from EEPROM
        user_id = EE_Read(eeprom_address) * 100 +
                  EE_Read(eeprom_address + 1) * 10 +
                  EE_Read(eeprom_address + 2);
        eeprom_address += 3; // Move to the next address for the next data

        // Check and skip delimiter between user id and password
        if (EE_Read(eeprom_address) != DELIMITER)
            {
            // Handle delimiter error or end of data
            break;
            }
        eeprom_address++;

        // Read User Password (3 digits) from EEPROM
        user_password = EE_Read(eeprom_address) * 100 +
                        EE_Read(eeprom_address + 1) * 10 +
                        EE_Read(eeprom_address + 2);
        eeprom_address += 3; // Move to the next address for the next data

        // Check and skip delimiter between different users
        if (EE_Read(eeprom_address) != DELIMITER)
            {
            // Handle delimiter error or end of data
            break;
            }
        eeprom_address++;

        // Display the read data
        lcd_clear();
        //lcd_printf("Name: %s, ID: %d, P: %d\n", user_name, user_id, user_password);
        //delay_ms(900);
        }
}

unsigned char EE_Read(unsigned int address)
{
    EEPROM_WAIT;    // Wait till EEPROM is ready
    EEAR = address; // Prepare the address you want to read from
    EECR.0 = 1;      // Execute read command
    return EEDR;
}

void EE_Write(unsigned int address, unsigned char data)
{
    EEPROM_WAIT;    // Wait till EEPROM is ready
    EEAR = address; // Prepare the address you want to read from
    EEDR = data;    // Prepare the data you want to write in the address above
    EECR.2 = 1;      // Master write enable
    EECR.1 = 1;      // Write Enable
    EEPROM_WAIT;    // Wait till EEPROM is ready
    EECR.1 = 0;      // Clear Write Enable bit
}

void motor()
{
    int i;
    for (i = 0; i < 5; i++) {
        // Door closed
        PORTD |= (1 << PORTD0);  // PORTD.0 = 1
        PORTD &= ~(1 << PORTD1); // PORTD.1 = 0
        delay_ms(1000);

        // Door opening
        PORTD &= ~(1 << PORTD0); // PORTD.0 = 0
        delay_ms(1000);

//        // Door open
//        PORTD |= (1 << PORTD1);  // PORTD.1 = 1
//        delay_ms(1000);
//
//        // Door closing
//        PORTD &= ~(1 << PORTD1); // PORTD.1 = 0
//        delay_ms(1000);
    }
}

void Buzz()
{
    PORTD.5 = 1; // Assuming PD5 is connected to the sounder
    delay_ms(100); // Adjust the delay as needed
    PORTD.5 = 0;
}

char keypad()
{
    while (1)
        {
        PORTC.0 = 0; // C0 is on, C1 and C2 are off
        PORTC.1 = 1;
        PORTC.2 = 1;

        switch (PINC)
            {
            case 0b11110110:
                while (PINC.3 == 0)
                    ; // While the button is pressed, Wait!
                return '1';
                break;

            case 0b11101110:
                while (PINC.4 == 0)
                    ; // While the button is pressed, Wait!
                return '4';
                break;

            case 0b11011110:
                while (PINC.5 == 0)
                    ; // While the button is pressed, Wait!
                return '7';
                break;

            case 0b10111110:
            case 0b10111101:
            case 0b10111011:
                while (PINC.6 == 0)
                    ; // While the button is pressed, Wait!
                return '*';
                break;
            }

        PORTC.0 = 1; // C1 is on, C0 and C2 are off
        PORTC.1 = 0;
        PORTC.2 = 1;

        switch (PINC)
            {
            case 0b11110101:
                while (PINC.3 == 0)
                    ; // While the button is pressed, Wait!
                return '2';
                break;

            case 0b11101101:
                while (PINC.4 == 0)
                    ; // While the button is pressed, Wait!
                return '5';
                break;

            case 0b11011101:
                while (PINC.5 == 0)
                    ; // While the button is pressed, Wait!
                return '8';
                break;

            case 0b10111101:
                while (PINC.6 == 0)
                    ; // While the button is pressed, Wait!
                return '0';
                break;
            }

        PORTC.0 = 1; // C2 is on, C0 and C1 are off
        PORTC.1 = 1;
        PORTC.2 = 0;

        switch (PINC)
            {
            case 0b11110011:
                while (PINC.3 == 0)
                    ; // While the button is pressed, Wait!
                return '3';
                break;

            case 0b11101011:
                while (PINC.4 == 0)
                    ; // While the button is pressed, Wait!
                return '6';
                break;

            case 0b11011011:
                while (PINC.5 == 0)
                    ; // While the button is pressed, Wait!
                return '9';
                break;
            }
        }
}

interrupt [EXT_INT0] void ext_int0_isr(void)
{
    char adminPC[3];
    int i;
    bool admin;
    lcd_clear();
    lcd_printf("Enter Admin PC: ");

    for (i = 0; i < 3; i++)
        {
        adminPC[i] = keypad();
        lcd_putchar(adminPC[i]);
        }

    admin = checkPassCode(adminPC, 10);

    // Check Admin PC
    if (!admin)
        {
        lcd_clear();
        lcd_printf("Contact Admin"); 
        Buzz();
        Buzz();
        }
    else
        AdminEdit();
}

interrupt [EXT_INT1] void ext_int1_isr(void)
{
    UserEdit();
}