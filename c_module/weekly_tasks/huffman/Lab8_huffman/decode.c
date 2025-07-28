#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_SYMBOLS 255
#define MAX_LEN     10

struct tnode
{
    struct  tnode* left; /*used when in tree*/
    struct  tnode*right; /*used when in tree*/  
    int     isleaf;
    char     symbol;
};

struct code
{
	int		symbol;
	char	strcode[MAX_LEN];
};

/*global variables*/
struct tnode* root=NULL; /*tree of symbols*/

/*
    @function   talloc
    @desc       allocates new node 
*/
struct tnode* talloc()
{
    struct tnode* p=(struct tnode*)malloc(sizeof(struct tnode)); // allocate memory
    if(p!=NULL)
    { // Initialize
        p->left = p->right = NULL;
        p->symbol=0;
		p->isleaf=0;
    }
    return p; // Return pointer
}

/*
    @function build_tree
    @desc     builds the symbol tree given the list of symbols and code.h
	NOTE: alters the global variable root that has already been allocated in main
*/
void build_tree(FILE* fp)
{
	char	symbol;
	char	strcode[MAX_LEN];
	int		items_read;
	int		i,len;
	struct	tnode* curr=NULL;

	while(!feof(fp))
	{
		items_read = fscanf(fp,"%c %s\n", &symbol, strcode);

		if(items_read!=2){
			break;
		}

		curr = root;
		len = strlen(strcode);

		for(i = 0; i < len; i++)
		{
			/*TODO: create the tree as you go*/
			if (strcode[i] == '0') {
				if (!curr->left){
					curr->left = talloc(); // 29:Allocate memory, Initialize, Return pointer
				}
				curr = curr->left;
			}
			else {
				if (!curr->right){
					curr->right = talloc(); // 29:Allocate memory, Initialize, Return pointer
				}
				curr = curr->right;
			}
		}
		/*assign code*/
		curr->isleaf = 1;
		curr->symbol = symbol;
		printf("inserted symbol:%c\n", symbol);
	}
}

/*
	function decode
*/
void decode(FILE* fin,FILE* fout)
{
	char c;
	struct tnode* curr=root;
	while((c = getc(fin)) != EOF)
	{
		/*TODO:
			traverse the tree
			print the symbols only if you encounter a leaf node
		*/
		if (c == '0'){ // 0 for left
			curr = curr->left;
		}

		else if(c == '1'){ // 1 for right
			curr = curr->right;
		}

		if (curr->isleaf) { // if leaf then it is root
			fputc(curr->symbol, fout); // fout set the alphabets
			curr = root; // once set the symbol then reset it to the begining for next symbol
		}
	}
}
/*
	@function freetree
	@desc	  cleans up resources for tree
*/

void freetree(struct tnode* root)
{
	if(root==NULL)
		return;
	freetree(root->right);
	freetree(root->left);
	free(root);
}
int main()
{
	const char* IN_FILE="encoded.txt"; // Input file
	const char* CODE_FILE="code.txt"; // Input file
	const char* OUT_FILE="decoded.txt"; // Output file
	FILE* fout;
	FILE* fin;
	/*allocate root*/
	root=talloc();
	fin=fopen(CODE_FILE,"r"); // read fin input
	/*build tree*/
	build_tree(fin);
	fclose(fin);

	/*decode*/
	fin=fopen(IN_FILE,"r");
	fout=fopen(OUT_FILE,"w"); // write fout output
	decode(fin,fout);
	fclose(fin);
	fclose(fout);
	/*cleanup*/
	freetree(root);
	// getchar();
	return 0;
}
//====================================================jbckbwkvbkl