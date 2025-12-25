import React from 'react';
import { useDrag } from 'react-dnd';

const DraggableItem = ({ name }) => {
  const [{ isDragging }, drag] = useDrag({
    type: 'CARD', // Specify the type property
    item: { name },
    collect: (monitor) => ({
      isDragging: !!monitor.isDragging(),
    }),
  });

  return (
    <div
      ref={drag}
      style={{
        opacity: isDragging ? 0.5 : 1,
        cursor: 'move',
        border: '1px solid #ccc',
        padding: '8px',
        marginBottom: '8px',
      }}
    >
      {name}
    </div>
  );
};

export default DraggableItem;
