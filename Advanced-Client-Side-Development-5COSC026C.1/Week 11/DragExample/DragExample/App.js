import React, { useState } from 'react';
import { DndProvider } from 'react-dnd';
import { HTML5Backend } from 'react-dnd-html5-backend';
import DraggableItem from './DraggableItem';
import DropTarget from './DropTarget';

const App = () => {
  const [droppedItem, setDroppedItem] = useState(null);

  const handleDrop = (item) => {
    setDroppedItem(item.name);
  };

  return (
    <DndProvider backend={HTML5Backend}>
      <div>
        <h2>Drag and Drop Example</h2>
        <DropTarget onDrop={handleDrop}>
          {droppedItem ? (
            <p>Item dropped: {droppedItem}</p>
          ) : (
            <p>Drop here</p>
          )}
        </DropTarget>
        <DraggableItem name="Item 1" />
        <DraggableItem name="Item 2" />
        <DraggableItem name="Item 3" />
      </div>
    </DndProvider>
  );
};

export default App;
