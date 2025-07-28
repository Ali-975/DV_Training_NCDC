/* A program shell to maintain a linked list of names */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/* Maximum length of names */
#define MAXSTRLEN   127

/* Stringify a literal without macro expansion */
#define STR(EXPR) #EXPR

/* Construct a size-limited scanf format string for a character buffer */
#define SCANSTR(LEN) "%" STR(LEN) "s"

typedef struct node node_t;

struct node
{ char data[MAXSTRLEN+1];
  node_t* next;
};

/* function prototypes, listed in alphabetical order */

void
addName (node_t ** firstPtr);
/* pre-condition:  firstPtr points to the pointer
                   designating the head of a list
  post-condition:  a name is read and
                   inserted into the list at a designated place
*/

void
countList (const node_t * first);
/* pre-condition:  first designates the first node of a list 
  post-condition:  the number of items on the list is counted and printed
                   the list itself is unchanged
*/

void
deleteName (node_t ** firstPtr);
/* pre-condition:  firstPtr points to the pointer designating the head of a list
  post-condition:  a name is read and
                   that name is deleted from the list
*/

void
print (const node_t * first);
/* pre-condition:  first designates the first node of a list 
  post-condition:  The items on the list are printed from first to last
                   the list itself is unchanged
  note:  processing proceeds iteratively
*/

void
printRec (const node_t * first);
/* pre-condition:  first designates the first node of a list 
  post-condition:  The items on the list are printed from first to last
                   the list itself is unchanged
  note:  processing proceeds recursively
*/

void
printLast (const node_t * first);
/* pre-condition:  first designates the first node of a list 
  post-condition:  the last item on the list is printed; 
                   the list itself is unchanged
  note:  processing proceeds iteratively
*/

void
printLastRec (const node_t * first);
/* pre-condition:  first designates the first node of a list 
  post-condition:  the last item on the list is printed; 
                   the list itself is unchanged
  note:  processing proceeds recursively
*/

void
printReverse (const node_t * first);
/* pre-condition:  first designates the first node of a list 
  post-condition:  The items on the list are printed from last to first
                   the list itself is unchanged
*/

void
putFirst (node_t ** firstPtr);
/* pre-condition:  first designates the first node of a list 
  post-condition:  a name is read, located on the list,
                   and placed at the beginning of the list
  note:  processing proceeds iteratively
*/


/* helper function to read a string into a buffer of length MAXSTRLEN */
void
getString (const char * prompt, char * buffer)
{
  int numTokens;
  do {
    printf ("%s", prompt);
    numTokens = scanf (SCANSTR(MAXSTRLEN), buffer);
    if (numTokens==0) {
      printf ("Error reading value. Please try again.\n");
      continue;
    }
  } while (numTokens==0);
} // getString


/* Print menu options to the screen */
void
printMenu (void)
{
  printf ("Options available\n");
  printf ("I - Insert a name into the list\n");
  printf ("D - Delete a name from the list\n");
  printf ("C - Count the number of items on the list\n");
  printf ("F - Move an item to the front of the list\n");
  printf ("L - Print the last item on the list (iteratively)\n");
  printf ("M - Print the last item on the list (recursively)\n");
  printf ("P - Print the names on the list (iteratively)\n");
  printf ("S - Print the names on the list (recursively)\n");
  printf ("R - Print the names in reverse order\n");
  printf ("Q - Quit\n");
} // printMenu


/* program to coordinate the menu options and call the requested function */
int
main (void)
{
  node_t * first = NULL;   /* pointer to the first list item */
  char option [MAXSTRLEN+1];          /* user response to menu selection */

  printf ("Program to Maintain a List of Names\n");

  while (1) {
      printMenu(); /* print menu options */
      getString ("Enter desired option: ", option); /* get user selection */
    
      switch (tolower(option[0])) {
        case 'i': addName (&first);
          break;
        case 'd': deleteName (&first);
          break;
        case 'c': countList (first);
          break;
        case 'f': putFirst(&first);
          break;
        case 'l': printLast(first);
          break;
        case 'm': printLastRec(first);
          break;
        case 'p': print(first);
          break;
        case 's': printRec(first);
          break;
        case 'r': printReverse(first);
          break;
        case 'q':
          printf ("Program terminated\n");
          return 0;
          break;
        default: printf ("Invalid Option - Try Again!\n");
          continue;
      } // switch
  } // while
} // main

void
addName (node_t ** firstPtr) {
/* pre-condition:  firstPtr points to the pointer designating the head of a list
  post-condition:  a name is read and
                   inserted into the list at a designated place
*/

  char oldName [MAXSTRLEN+1];
  node_t * newNode = malloc (sizeof (node_t));
  node_t * listPtr;
  node_t * prevPtr;
  
  if (newNode==NULL) {
    perror ("Unable to allocate node");
    return;
  }

  getString ("Enter name to be inserted into list: ", newNode->data);

  if (*firstPtr == NULL) {
    /* insert name's node at start of list */
    newNode->next = *firstPtr;
    *firstPtr = newNode;
  }
  else {
    getString ( "Enter old name which new name should precede, \n"
                "or enter ? if new name should be placed last: ", oldName );
        
    if (strncmp (oldName, (*firstPtr)->data, MAXSTRLEN) == 0) {
      /* insert name's node at start of list */
      newNode->next = *firstPtr;
      *firstPtr = newNode;
    }
    else {
      /* insert name's node after start of the list */
      
      /* start at beginning of list */
      listPtr = (*firstPtr)->next;  /* the current node to search */
      prevPtr = *firstPtr;          /* the node behind listPtr */
      
      while (listPtr!=NULL &&
             strncmp (oldName, listPtr->data, MAXSTRLEN) != 0) {
        prevPtr = listPtr;
        listPtr = prevPtr->next;
      } // while

      newNode->next = prevPtr->next;
      prevPtr->next = newNode;
    } // else if strncmp
  } // else if *firstPtr == NULL
  printf ("%s inserted into the list\n\n", newNode->data);
} // addName

void
countList (const node_t * first) {
/* pre-condition:  first designates the first node of a list 
  post-condition:  the number of items on the list is counted and printed
                   the list itself is unchanged
*/
  printf ("Function countList is not implemented at present\n\n");
} // countList

void
deleteName (node_t ** firstPtr) {
/* pre-condition:  firstPtr points to the pointer designating the head of a list
  post-condition:  a name is read and
                   that name is deleted from the list
*/
  char name [MAXSTRLEN+1];
  node_t * listPtr;
  node_t * prevPtr;

  if (*firstPtr) {/* list is non-empty */
    getString ("Enter name to be deleted: ", name);
    
    if (strncmp(name, (*firstPtr)->data, MAXSTRLEN) == 0) {
      /* remove first item on list */
      listPtr = *firstPtr;
      *firstPtr = (*firstPtr)->next;
      free(listPtr);
      printf("%s removed as first item on list\n\n", name);
    }
    else {
      /* item to remove is not at beginning of list */
      /* start at beginning of list */
      listPtr = (*firstPtr)->next;  /* the current node to search */
      prevPtr = *firstPtr;          /* the node behind listPtr */
      
      while ( (listPtr != NULL) &&
              (strncmp (name, listPtr->data, MAXSTRLEN) != 0)) {
        prevPtr = listPtr;
        listPtr = prevPtr->next;
      } // while

      /* determine whether we ran out of items or found match */
      if (listPtr != NULL) { 
        /* remove item from list */
        prevPtr->next = listPtr->next;
        free (listPtr);
        printf ("%s deleted from list\n\n", name);
      }
      else {
        printf ("%s not found on list\n\n", name);
      }
    } /* end processing of name */
  }
  else {
    printf ("List is empty - no deletions are possible\n");
  } 
}  // deleteName

void
print (const node_t * first) {
/* pre-condition:  first designates the first node of a list 
  post-condition:  The items on the list are printed from first to last
                   the list itself is unchanged
  note:  processing proceeds iteratively
*/    

  printf ("The names on the list are:\n\n");

  for (node_t * current = (node_t *) first ; // discard const for iteration
       current != NULL ;
       current = current->next )
  {
    printf ("%s\n", current->data);
  }

  printf ("\nEnd of List\n\n");
} // print

void
printRec (const node_t * first) {
/* pre-condition:  first designates the first node of a list 
  post-condition:  The items on the list are printed from first to last
                   the list itself is unchanged
  note:  processing proceeds recursively
*/
  printf ("Function printRec is not implemented at present\n\n");
} // printRec

void
printLast (const node_t * first) {
/* pre-condition:  first designates the first node of a list 
  post-condition:  the last item on the list is printed; 
                   the list itself is unchanged
  note:  processing proceeds iteratively
*/
  printf ("Function printLast is not implemented at present\n\n");
} // printLast

void
printLastRec (const node_t * first) {
/* pre-condition:  first designates the first node of a list 
  post-condition:  the last item on the list is printed; 
                   the list itself is unchanged
  note:  processing proceeds recursively
*/
  printf ("Function printLastRec is not implemented at present\n\n");
} //printLastRec

void
printReverse (const node_t * first) {
/* pre-condition:  first designates the first node of a list 
  post-condition:  The items on the list are printed from last to first
                   the list itself is unchanged
*/
  printf ("Function printReverse is not implemented at present\n\n");
} // printReverse

void
putFirst (node_t ** firstPtr) {
/* pre-condition:  first designates the first node of a list 
  post-condition:  a name is read, located on the list,
                   and placed at the beginning of the list
*/
  printf ("Function putFirst is not implemented at present\n\n");
} // putFirst
