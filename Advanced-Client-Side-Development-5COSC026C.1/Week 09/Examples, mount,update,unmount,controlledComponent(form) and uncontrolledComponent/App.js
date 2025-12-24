import React from 'react';
import MountingExample from './components/MountingExample';
import UpdatingExample from './components/UpdatingExample';
import UnmountingExample from './components/UnmountingExample';
import ControlledFormExample from './components/ControlledFormExample'; // Import the controlled form component
import UncontrolledFormExample from './components/UncontrolledFormExample'; // Import the uncontrolled form component

function App() {
  return (
    <div>
      <h2>Welcome to My React App</h2>
      <MountingExample message="Red" />
	  {/*<UpdatingExample />
	  <UnmountingExample />
	  <ControlledFormExample />
	  <UncontrolledFormExample />*/}
    </div>
  );
}

export default App;

