# Word Cloud Generator

This project implements a **Word Cloud Generator** in **Racket**, which visualizes the most frequently used words from a given text file. Words
are filtered, counted, and transformed into a cloud of colorful text, with the frequency of a word determining its size in the final image.

## Features
- Reads a text file, processes the words, and generates a frequency distribution.
- Filters out common words such as "a", "the", "is", etc.
- Generates a word cloud image with words displayed in random colors and sizes based on their frequency.
- Stacks and sequences the words in visually appealing arrangements.

## How It Works

### Input
The program accepts a text file as input. It processes this file to:
1. Read all the words and count their occurrences, ignoring common words.
2. Select the top 50 most frequent words.
3. Transform the words into a visual representation, assigning random colors and sizes based on word frequency.

### Word Cloud Construction
1. **Word Frequency**: Words are counted using a hash table to store frequencies efficiently.
2. **Image Transformation**: The most frequent words are converted into text images of various font sizes and colors.
3. **Arrangement**: The program uses a combination of `stack`, `sequence`, and custom recursive procedures to arrange the words into an aesthetically pleasing word cloud.
   
### Custom Functions
- **`count`**: Counts the occurrences of words in the text file.
- **`counted`**: Converts the word frequency hash table into a list of word-frequency pairs.
- **`sorted`**: Sorts the word-frequency pairs in descending order by frequency.
- **`top-50`**: Selects the top 50 words by frequency.
- **`change-image`**: Converts the selected words into a visual representation, with sizes and colors varying based on frequency.
- **`stack` and `sequence`**: Arranges the words in the final word cloud.

## Prerequisites

- **Racket**: This program is written in Racket and requires a Racket installation.
- **Libraries**: 
  - `csc151`
  - `2htdp/image`

You can install these libraries in your Racket environment using:
```racket
(require csc151)
(require 2htdp/image)
```

## Running the Program

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/WordCloudRacket.git
   ```
   
2. **Open the Project in Racket**:
   - Load the `word-cloud.rkt` file in your DrRacket IDE or run it using the Racket command line.

3. **Generate the Word Cloud**:
   - To create a word cloud from a file, run the `word-cloud` function:
     ```racket
     (word-cloud "path/to/your/textfile.txt")
     ```
   
4. **Save the Word Cloud**:
   - You can save the generated word cloud as an image file:
     ```racket
     (save-image (word-cloud "path/to/your/textfile.txt") "output.png")
     ```

## Example Usage
```racket
> (word-cloud "filename.txt")
```

This will generate and display a word cloud based on the contents of `filename.txt`.

To save the image:
```racket
(save-image (word-cloud "filename.txt") "sample.png")
```

## Acknowledgements
This project was created as part of CSC-151 coursework, utilizing materials and references from the course website, DrRacket documentation,
and assistance from Samuel Reblsky.
