/*
 * @flow
 * Copyright (C) 2018 MetaBrainz Foundation
 *
 * This file is part of MusicBrainz, the open internet music database,
 * and is licensed under the GPL version 2, or (at your option) any
 * later version: http://www.gnu.org/licenses/gpl-2.0.txt
 */

import React from 'react';

import ConfirmLayout from '../components/ConfirmLayout';
import EditorLink from '../static/scripts/common/components/EditorLink';

const Nominate = ({candidate}: {+candidate: EditorT}) => (
  <ConfirmLayout
    question={exp.l(
      `Are you sure you want to nominate the editor {editor}
       for auto-editor status?`,
      {editor: <EditorLink editor={candidate} key="editor" />},
    )}
    title={l('Nominate a candidate for auto-editor')}
  />
);

export default Nominate;
