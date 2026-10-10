// controllers/userController.js
const db = require('../config/db');

// @desc    Get current user
// @route   GET /api/users/me
// @access  Private
exports.getCurrentUser = async (req, res) => {
  try {
    // Get user data
    const [users] = await db.query(`
      SELECT id, name, email, profile_picture, phone_number, 
      professional_credentials, years_of_experience, license_number, bio
      FROM users WHERE id = ?
    `, [req.user.id]);
    
    if (users.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
      });
    }
    
    const user = users[0];
    
    // Get specializations
    const [specializations] = await db.query(
      'SELECT specialization FROM user_specializations WHERE user_id = ?',
      [req.user.id]
    );
    
    // Get certifications
    const [certifications] = await db.query(
      'SELECT certification FROM user_certifications WHERE user_id = ?',
      [req.user.id]
    );
    
    // Format the response to match the frontend expectations
    const formattedUser = {
      id: user.id,
      name: user.name,
      email: user.email,
      profilePicture: user.profile_picture,
      phoneNumber: user.phone_number,
      professionalCredentials: user.professional_credentials,
      yearsOfExperience: user.years_of_experience,
      licenseNumber: user.license_number,
      bio: user.bio,
      specializations: specializations.map(s => s.specialization),
      certifications: certifications.map(c => c.certification)
    };

    res.status(200).json(formattedUser);
  } catch (error) {
    console.error('Get user error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error',
    });
  }
};

// @desc    Update user profile
// @route   PUT /api/users/profile
// @access  Private
exports.updateProfile = async (req, res) => {
  try {
    const {
      name,
      professional_credentials,
      license_number,
      phone_number,
      bio,
      specializations,
      years_of_experience,
      profile_picture,
    } = req.body;

    // Start a transaction
    const connection = await db.getConnection();
    await connection.beginTransaction();

    try {
      // Update user basic info
      const updateFields = [];
      const updateValues = [];
      
      if (name) {
        updateFields.push('name = ?');
        updateValues.push(name);
      }
      
      if (professional_credentials !== undefined) {
        updateFields.push('professional_credentials = ?');
        updateValues.push(professional_credentials);
      }
      
      if (license_number !== undefined) {
        updateFields.push('license_number = ?');
        updateValues.push(license_number);
      }
      
      if (phone_number !== undefined) {
        updateFields.push('phone_number = ?');
        updateValues.push(phone_number);
      }
      
      if (bio !== undefined) {
        updateFields.push('bio = ?');
        updateValues.push(bio);
      }
      
      if (years_of_experience !== undefined) {
        updateFields.push('years_of_experience = ?');
        updateValues.push(years_of_experience);
      }
      
      if (profile_picture !== undefined) {
        updateFields.push('profile_picture = ?');
        updateValues.push(profile_picture);
      }
      
      if (updateFields.length > 0) {
        const query = `UPDATE users SET ${updateFields.join(', ')} WHERE id = ?`;
        await connection.query(query, [...updateValues, req.user.id]);
      }
      
      // Update specializations if provided
      if (specializations) {
        // Delete existing specializations
        await connection.query('DELETE FROM user_specializations WHERE user_id = ?', [req.user.id]);
        
        // Add new specializations
        if (specializations.length > 0) {
          const values = specializations.map(spec => [req.user.id, spec]);
          await connection.query(
            'INSERT INTO user_specializations (user_id, specialization) VALUES ?',
            [values]
          );
        }
      }
      
      // Commit the transaction
      await connection.commit();
      connection.release();
      
      // Get updated user
      const updatedUser = await this.getCurrentUser(req, res);
      
    } catch (error) {
      // If error, rollback changes
      await connection.rollback();
      connection.release();
      throw error;
    }
  } catch (error) {
    console.error('Update profile error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error',
    });
  }
};

// @desc    Get user stats
// @route   GET /api/users/stats
// @access  Private
exports.getUserStats = async (req, res) => {
  try {
    // Get professional developments
    const [developments] = await db.query(`
      SELECT id, title, type, completion_date, certificate_url, provider, credit_hours, description
      FROM professional_developments
      WHERE user_id = ?
      ORDER BY completion_date DESC
    `, [req.user.id]);
    
    // Format professional developments
    const professionalDevelopments = developments.map(dev => ({
      id: dev.id,
      title: dev.title,
      type: dev.type,
      completionDate: dev.completion_date,
      certificateUrl: dev.certificate_url,
      provider: dev.provider,
      creditHours: dev.credit_hours,
      description: dev.description
    }));
    
    // Get achievements
    const [achievements] = await db.query(`
      SELECT id, title, description, icon_url, awarded_date, type, progress, goal
      FROM achievements
      WHERE user_id = ?
    `, [req.user.id]);
    
    // If no achievements in the database, create mock data
    let achievementsData = achievements.map(ach => ({
      id: ach.id,
      title: ach.title,
      description: ach.description,
      icon_url: ach.icon_url || '',
      awarded_date: ach.awarded_date,
      type: ach.type,
      progress: ach.progress,
      goal: ach.goal
    }));
    
    // If no achievements, add mock data
    if (achievementsData.length === 0) {
      achievementsData = [
        {
          id: 1,
          title: 'Century Club',
          description: 'Completed 100 patient sessions',
          icon_url: '',
          awarded_date: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString(),
          type: 'appointment',
          progress: 100,
          goal: 100,
        },
        {
          id: 2,
          title: 'Knowledge Seeker',
          description: 'Completed 5 professional development courses',
          icon_url: '',
          awarded_date: new Date(Date.now() - 60 * 24 * 60 * 60 * 1000).toISOString(),
          type: 'certification',
          progress: 5,
          goal: 5,
        },
      ];
    }
    
    // Mock data for other stats (in a real app, these would come from your database)
    const stats = {
      totalAppointments: 350,
      completedAppointments: 312,
      totalPatients: 145,
      connectionCount: 78,
      professionalDevelopments,
      totalCertifications: professionalDevelopments.filter(
        dev => dev.type === 'certification'
      ).length,
      achievements: achievementsData,
    };

    res.status(200).json(stats);
  } catch (error) {
    console.error('Get stats error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error',
    });
  }
};

// @desc    Update user preferences
// @route   PUT /api/users/preferences
// @access  Private
exports.updatePreferences = async (req, res) => {
  try {
    const {
      isDarkMode,
      language,
      timezone,
      notificationsEnabled,
      notificationSettings,
      privacySettings,
    } = req.body;

    // Check if user has preferences
    const [preferences] = await db.query(
      'SELECT * FROM user_preferences WHERE user_id = ?',
      [req.user.id]
    );
    
    // Build update fields
    const updateFields = [];
    const updateValues = [];
    
    if (isDarkMode !== undefined) {
      updateFields.push('is_dark_mode = ?');
      updateValues.push(isDarkMode);
    }
    
    if (language) {
      updateFields.push('language = ?');
      updateValues.push(language);
    }
    
    if (timezone) {
      updateFields.push('timezone = ?');
      updateValues.push(timezone);
    }
    
    if (notificationsEnabled !== undefined) {
      updateFields.push('notifications_enabled = ?');
      updateValues.push(notificationsEnabled);
    }
    
    // Notification settings
    if (notificationSettings) {
      if (notificationSettings.messageNotifications !== undefined) {
        updateFields.push('message_notifications = ?');
        updateValues.push(notificationSettings.messageNotifications);
      }
      
      if (notificationSettings.connectionRequestNotifications !== undefined) {
        updateFields.push('connection_request_notifications = ?');
        updateValues.push(notificationSettings.connectionRequestNotifications);
      }
      
      if (notificationSettings.appointmentNotifications !== undefined) {
        updateFields.push('appointment_notifications = ?');
        updateValues.push(notificationSettings.appointmentNotifications);
      }
      
      if (notificationSettings.certificateExpiryNotifications !== undefined) {
        updateFields.push('certificate_expiry_notifications = ?');
        updateValues.push(notificationSettings.certificateExpiryNotifications);
      }
    }
    
    // Privacy settings
    if (privacySettings) {
      if (privacySettings.isProfilePublic !== undefined) {
        updateFields.push('is_profile_public = ?');
        updateValues.push(privacySettings.isProfilePublic);
      }
      
      if (privacySettings.showContactInfo !== undefined) {
        updateFields.push('show_contact_info = ?');
        updateValues.push(privacySettings.showContactInfo);
      }
      
      if (privacySettings.allowConnectionRequests !== undefined) {
        updateFields.push('allow_connection_requests = ?');
        updateValues.push(privacySettings.allowConnectionRequests);
      }
      
      if (privacySettings.showProfessionalNetwork !== undefined) {
        updateFields.push('show_professional_network = ?');
        updateValues.push(privacySettings.showProfessionalNetwork);
      }
      
      if (privacySettings.participateInRecommendations !== undefined) {
        updateFields.push('participate_in_recommendations = ?');
        updateValues.push(privacySettings.participateInRecommendations);
      }
    }
    
    if (updateFields.length > 0) {
      if (preferences.length === 0) {
        // Create preferences if not exists
        await db.query('INSERT INTO user_preferences (user_id) VALUES (?)', [req.user.id]);
      }
      
      // Update preferences
      const query = `UPDATE user_preferences SET ${updateFields.join(', ')} WHERE user_id = ?`;
      await db.query(query, [...updateValues, req.user.id]);
    }
    
    // Get updated preferences
    const [updatedPreferences] = await db.query(`
      SELECT * FROM user_preferences
      WHERE user_id = ?
    `, [req.user.id]);
    
    if (updatedPreferences.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'User preferences not found',
      });
    }
    
    // Format the preferences to match frontend expectations
    const pref = updatedPreferences[0];
    const formattedPreferences = {
      isDarkMode: pref.is_dark_mode === 1,
      language: pref.language,
      timezone: pref.timezone,
      notificationsEnabled: pref.notifications_enabled === 1,
      notificationSettings: {
        messageNotifications: pref.message_notifications === 1,
        connectionRequestNotifications: pref.connection_request_notifications === 1,
        appointmentNotifications: pref.appointment_notifications === 1,
        certificateExpiryNotifications: pref.certificate_expiry_notifications === 1,
      },
      privacySettings: {
        isProfilePublic: pref.is_profile_public === 1,
        showContactInfo: pref.show_contact_info === 1,
        allowConnectionRequests: pref.allow_connection_requests === 1,
        showProfessionalNetwork: pref.show_professional_network === 1,
        participateInRecommendations: pref.participate_in_recommendations === 1,
      },
    };

    res.status(200).json(formattedPreferences);
  } catch (error) {
    console.error('Update preferences error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error',
    });
  }
};

// @desc    Get user connections
// @route   GET /api/users/connections
// @access  Private
exports.getUserConnections = async (req, res) => {
  try {
    // Mock data for connections
    // In a real app, this would come from your connections table
    const connections = [
      {
        id: 2,
        name: 'Dr. John Davis',
        email: 'john.davis@example.com',
        profilePicture: 'https://randomuser.me/api/portraits/men/32.jpg',
        professionalCredentials: 'PT, OCS',
        specializations: ['Orthopedic', 'Pain Management'],
      },
      {
        id: 3,
        name: 'Dr. Sarah Johnson',
        email: 'sarah.johnson@example.com',
        profilePicture: 'https://randomuser.me/api/portraits/women/67.jpg',
        professionalCredentials: 'PT, DPT, GCS',
        specializations: ['Geriatric', 'Neurological'],
      },
    ];

    res.status(200).json(connections);
  } catch (error) {
    console.error('Get connections error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error',
    });
  }
};

// @desc    Add professional development
// @route   POST /api/users/professional-development
// @access  Private
exports.addProfessionalDevelopment = async (req, res) => {
  try {
    const {
      title,
      type,
      completionDate,
      certificateUrl,
      provider,
      creditHours,
      description,
    } = req.body;

    // Insert professional development
    const [result] = await db.query(`
      INSERT INTO professional_developments 
      (user_id, title, type, completion_date, certificate_url, provider, credit_hours, description)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    `, [
      req.user.id,
      title,
      type,
      new Date(completionDate),
      certificateUrl || null,
      provider || null,
      creditHours || null,
      description || null
    ]);

    // Get the newly created record
    const [developments] = await db.query(
      'SELECT * FROM professional_developments WHERE id = ?',
      [result.insertId]
    );

    // Format the response
    const dev = developments[0];
    const formattedDev = {
      id: dev.id,
      title: dev.title,
      type: dev.type,
      completionDate: dev.completion_date,
      certificateUrl: dev.certificate_url,
      provider: dev.provider,
      creditHours: dev.credit_hours,
      description: dev.description,
    };

    res.status(201).json(formattedDev);
  } catch (error) {
    console.error('Add development error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error',
    });
  }
};

// @desc    Search professionals
// @route   GET /api/users/search
// @access  Private
exports.searchProfessionals = async (req, res) => {
  try {
    const { q, specializations } = req.query;

    let query = `
      SELECT u.id, u.name, u.email, u.profile_picture, u.professional_credentials
      FROM users u
      WHERE u.id != ?
    `;
    
    let params = [req.user.id];

    // Search by name or email
    if (q) {
      query += ' AND (u.name LIKE ? OR u.email LIKE ?)';
      params.push(`%${q}%`, `%${q}%`);
    }

    // Filter by specializations
    if (specializations) {
      const specializationArray = specializations.split(',');
      query += `
        AND u.id IN (
          SELECT user_id 
          FROM user_specializations 
          WHERE specialization IN (?)
          GROUP BY user_id
          HAVING COUNT(DISTINCT specialization) = ?
        )
      `;
      params.push(specializationArray, specializationArray.length);
    }

    // Execute query
    const [users] = await db.query(query, params);

    // Get specializations for each user
    const formattedUsers = await Promise.all(users.map(async (user) => {
      const [specializations] = await db.query(
        'SELECT specialization FROM user_specializations WHERE user_id = ?',
        [user.id]
      );

      return {
        id: user.id,
        name: user.name,
        email: user.email,
        profilePicture: user.profile_picture,
        professionalCredentials: user.professional_credentials,
        specializations: specializations.map(s => s.specialization),
      };
    }));

    res.status(200).json(formattedUsers);
  } catch (error) {
    console.error('Search error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error',
    });
  }
};