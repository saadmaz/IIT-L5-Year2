import React from 'react';
import { useDrop } from 'react-dnd';

const DropTarget = ({ onDrop, children }) => {
  const [{ isOver }, drop] = useDrop({
    accept: 'CARD',
    drop: (item) => onDrop(item),
    collect: (monitor) => ({
      isOver: !!monitor.isOver(),
    }),
  });

  return (
    <div
      ref={drop}
      style={{
        border: isOver ? '2px dashed #000' : '1px solid #ccc',
        padding: '16px',
      }}
    >
      {children}
    </div>
  );
};

export default DropTarget;
